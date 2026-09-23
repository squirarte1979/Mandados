-- Ejecutar DESPUÉS de supabase-schema.sql
alter table profiles add column if not exists is_admin boolean default false;
alter table orders add column if not exists service_fee numeric(12,2) default 0;
alter table orders add column if not exists merchandise_total numeric(12,2) default 0;
alter table orders add column if not exists total numeric(12,2) default 0;

create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path=public as $$
  select coalesce((select is_admin from profiles where id=auth.uid()),false);
$$;

create policy "admins profiles read" on profiles for select using (public.is_admin());
create policy "admins addresses read" on addresses for select using (public.is_admin());
create policy "admins orders all" on orders for all using (public.is_admin()) with check (public.is_admin());
create policy "admins order items all" on order_items for all using (public.is_admin()) with check (public.is_admin());

-- Después de crear tu usuario administrador, sustituye el correo:
-- update profiles p set is_admin=true from auth.users u where p.id=u.id and u.email='TU_CORREO@DOMINIO.COM';
