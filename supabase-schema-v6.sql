-- Mandados Quirarte Araiza v0.6
-- Ejecutar después de supabase-schema-v5.sql.
-- Permite varios tickets por pedido y calcula 20% sobre la suma de todos.

create table if not exists order_tickets (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references orders(id) on delete cascade,
  store_name text,
  amount numeric(12,2) not null default 0 check (amount >= 0),
  created_at timestamptz not null default now()
);

alter table order_tickets enable row level security;
create policy "own order tickets read" on order_tickets for select
  using (exists(select 1 from orders o where o.id=order_id and o.user_id=auth.uid()));
create policy "admins order tickets all" on order_tickets for all
  using (public.is_admin()) with check (public.is_admin());

create or replace function public.recalculate_order_from_tickets(p_order_id uuid)
returns void language plpgsql security definer set search_path=public as $$
declare
  v_sum numeric(12,2);
  v_pct numeric(5,2);
begin
  select coalesce(sum(amount),0) into v_sum from order_tickets where order_id=p_order_id;
  select coalesce(service_percentage,20) into v_pct from orders where id=p_order_id;
  update orders set
    purchase_total=v_sum,
    merchandise_total=v_sum,
    service_fee=round(v_sum*v_pct/100.0,2),
    total=round(v_sum+(v_sum*v_pct/100.0),2)
  where id=p_order_id;
end;
$$;

create or replace function public.sync_order_ticket_totals()
returns trigger language plpgsql security definer set search_path=public as $$
begin
  perform public.recalculate_order_from_tickets(coalesce(new.order_id,old.order_id));
  if tg_op='UPDATE' and old.order_id is distinct from new.order_id then
    perform public.recalculate_order_from_tickets(old.order_id);
  end if;
  return coalesce(new,old);
end;
$$;

drop trigger if exists trg_sync_order_ticket_totals on order_tickets;
create trigger trg_sync_order_ticket_totals
after insert or update or delete on order_tickets
for each row execute function public.sync_order_ticket_totals();

-- Migra el total anterior como un primer ticket para no perder información.
insert into order_tickets(order_id,store_name,amount)
select id,'Compra anterior',purchase_total from orders
where coalesce(purchase_total,0)>0
and not exists(select 1 from order_tickets t where t.order_id=orders.id);
