create extension if not exists pgcrypto;
create table profiles (id uuid primary key references auth.users(id) on delete cascade, first_name text, last_name text, whatsapp text, created_at timestamptz default now());
create table addresses (id uuid primary key default gen_random_uuid(), user_id uuid references profiles(id) on delete cascade, label text default 'Casa', address text not null, references text, is_default boolean default true);
create table categories (id bigint generated always as identity primary key, name text unique not null, sort_order int default 0);
create table products (id bigint generated always as identity primary key, category_id bigint references categories(id), name text not null, active boolean default true, sort_order int default 0);
create table orders (id uuid primary key default gen_random_uuid(), user_id uuid references profiles(id), address_id uuid references addresses(id), folio bigint generated always as identity unique, status text default 'recibido' check(status in ('borrador','recibido','comprando','listo','en_reparto','entregado','cancelado')), source_order_id uuid references orders(id), created_at timestamptz default now(), submitted_at timestamptz);
create table order_items (id uuid primary key default gen_random_uuid(), order_id uuid references orders(id) on delete cascade, product_id bigint references products(id), custom_product text, quantity numeric, unit text, variety text, features text, brand_presentation text, actual_cost numeric(12,2));
create table saved_lists (id uuid primary key default gen_random_uuid(), user_id uuid references profiles(id) on delete cascade, name text default 'Mi lista habitual', created_at timestamptz default now(), updated_at timestamptz default now());
create table saved_list_items (id uuid primary key default gen_random_uuid(), saved_list_id uuid references saved_lists(id) on delete cascade, product_id bigint references products(id), custom_product text, quantity numeric, unit text, variety text, features text, brand_presentation text);

alter table profiles enable row level security; alter table addresses enable row level security; alter table orders enable row level security; alter table order_items enable row level security; alter table saved_lists enable row level security; alter table saved_list_items enable row level security;
create policy "own profile" on profiles for all using (auth.uid()=id) with check (auth.uid()=id);
create policy "own addresses" on addresses for all using (auth.uid()=user_id) with check (auth.uid()=user_id);
create policy "own orders" on orders for all using (auth.uid()=user_id) with check (auth.uid()=user_id);
create policy "own order items" on order_items for all using (exists(select 1 from orders o where o.id=order_id and o.user_id=auth.uid())) with check (exists(select 1 from orders o where o.id=order_id and o.user_id=auth.uid()));
create policy "own saved lists" on saved_lists for all using (auth.uid()=user_id) with check (auth.uid()=user_id);
create policy "own saved items" on saved_list_items for all using (exists(select 1 from saved_lists s where s.id=saved_list_id and s.user_id=auth.uid())) with check (exists(select 1 from saved_lists s where s.id=saved_list_id and s.user_id=auth.uid()));
