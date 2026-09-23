-- Mandados v0.7: ejecutar en Supabase SQL Editor DESPUÉS de v6.
-- Revisar respaldo antes de aplicar en producción. No ejecutar esquemas anteriores otra vez.
-- La administración se asigna únicamente desde SQL Editor con privilegios de propietario.

-- Impide que un cliente se convierta en administrador modificando su perfil.
create or replace function public.protect_profile_admin()
returns trigger language plpgsql security definer set search_path=public as $$
begin
  if auth.uid() is not null and not public.is_admin() then
    if tg_op='INSERT' and coalesce(new.is_admin,false) then
      raise exception 'No autorizado para asignar administración';
    end if;
    if tg_op='UPDATE' and new.is_admin is distinct from old.is_admin then
      raise exception 'No autorizado para cambiar administración';
    end if;
  end if;
  return new;
end; $$;
drop trigger if exists trg_protect_profile_admin on public.profiles;
create trigger trg_protect_profile_admin before insert or update on public.profiles
for each row execute function public.protect_profile_admin();

-- Un cliente puede consultar y crear pedidos, pero no editar importes o estados.
drop policy if exists "own orders" on public.orders;
create policy "client orders select" on public.orders for select to authenticated
using (auth.uid()=user_id);
create policy "client orders insert" on public.orders for insert to authenticated
with check (auth.uid()=user_id and status='recibido' and coalesce(purchase_total,0)=0
  and coalesce(merchandise_total,0)=0 and coalesce(service_fee,0)=0 and coalesce(total,0)=0
  and coalesce(service_percentage,20)=20
  and exists(select 1 from public.addresses a where a.id=address_id and a.user_id=auth.uid()));
-- La eliminación solo permite deshacer un pedido recién creado sin productos.
create policy "client orders rollback" on public.orders for delete to authenticated
using (auth.uid()=user_id and status='recibido' and created_at>now()-interval '5 minutes'
  and not exists(select 1 from public.order_items i where i.order_id=orders.id));

-- Los productos de un pedido enviado no se pueden alterar desde el navegador.
drop policy if exists "own order items" on public.order_items;
create policy "client order items select" on public.order_items for select to authenticated
using (exists(select 1 from public.orders o where o.id=order_id and o.user_id=auth.uid()));
create policy "client order items insert" on public.order_items for insert to authenticated
with check (quantity>0 and exists(select 1 from public.orders o where o.id=order_id
 and o.user_id=auth.uid() and o.status='recibido'
 and o.created_at>now()-interval '5 minutes'));
