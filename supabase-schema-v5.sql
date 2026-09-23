-- Mandados Quirarte Araiza v0.5
-- Ejecutar después de supabase-schema.sql y supabase-schema-v3.sql.
-- Cambia el modelo anterior de costos por producto a: total real del ticket + 20% de servicio.

alter table orders add column if not exists purchase_total numeric(12,2) default 0 check (purchase_total >= 0);
alter table orders add column if not exists service_percentage numeric(5,2) default 20 check (service_percentage >= 0);

create or replace function public.calculate_order_total()
returns trigger language plpgsql as $$
begin
  new.purchase_total := coalesce(new.purchase_total,0);
  new.service_percentage := coalesce(new.service_percentage,20);
  new.merchandise_total := new.purchase_total;
  new.service_fee := round(new.purchase_total * new.service_percentage / 100.0, 2);
  new.total := round(new.purchase_total + new.service_fee, 2);
  return new;
end;
$$;

drop trigger if exists trg_calculate_order_total on orders;
create trigger trg_calculate_order_total
before insert or update of purchase_total, service_percentage on orders
for each row execute function public.calculate_order_total();

-- Normaliza pedidos existentes al nuevo modelo cuando merchandise_total ya tenía el total de compra.
update orders set purchase_total=coalesce(nullif(purchase_total,0),merchandise_total,0), service_percentage=20;

-- Una sola dirección por cliente. Si existen duplicadas, conserva la más antigua.
with ranked as (
  select id,user_id,row_number() over(partition by user_id order by id) rn from addresses
)
delete from addresses a using ranked r where a.id=r.id and r.rn>1;
create unique index if not exists one_address_per_user on addresses(user_id);
