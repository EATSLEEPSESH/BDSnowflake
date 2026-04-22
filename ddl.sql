drop table if exists public.fact_sales cascade;
drop table if exists public.dim_date cascade;
drop table if exists public.dim_supplier cascade;
drop table if exists public.dim_store cascade;
drop table if exists public.dim_product cascade;
drop table if exists public.dim_seller cascade;
drop table if exists public.dim_customer cascade;

create table public.dim_customer (
    customer_id bigint primary key,
    customer_first_name text,
    customer_last_name text,
    customer_age bigint,
    customer_email text,
    customer_country text,
    customer_postal_code text,
    customer_pet_type text,
    customer_pet_name text,
    customer_pet_breed text
);

create table public.dim_seller (
    seller_id bigint primary key,
    seller_first_name text,
    seller_last_name text,
    seller_email text,
    seller_country text,
    seller_postal_code text
);

create table public.dim_product (
    product_id bigint primary key,
    product_name text,
    product_category text,
    product_price numeric(18,2),
    product_quantity bigint,
    pet_category text,
    product_weight numeric(18,2),
    product_color text,
    product_size text,
    product_brand text,
    product_material text,
    product_description text,
    product_rating numeric(18,2),
    product_reviews bigint,
    product_release_date date,
    product_expiry_date date
);

create table public.dim_store (
    store_id bigserial primary key,
    store_name text,
    store_location text,
    store_city text,
    store_state text,
    store_country text,
    store_phone text,
    store_email text
);

create table public.dim_supplier (
    supplier_id bigserial primary key,
    supplier_name text,
    supplier_contact text,
    supplier_email text,
    supplier_phone text,
    supplier_address text,
    supplier_city text,
    supplier_country text
);

create table public.dim_date (
    date_id bigserial primary key,
    full_date date unique,
    year bigint,
    month bigint,
    day bigint,
    quarter bigint
);

create table public.fact_sales (
    sale_id bigint primary key,
    customer_id bigint references public.dim_customer(customer_id),
    seller_id bigint references public.dim_seller(seller_id),
    product_id bigint references public.dim_product(product_id),
    store_id bigint references public.dim_store(store_id),
    supplier_id bigint references public.dim_supplier(supplier_id),
    date_id bigint references public.dim_date(date_id),
    sale_quantity bigint,
    sale_total_price numeric(18,2),
    product_price numeric(18,2),
    product_rating numeric(18,2),
    product_reviews bigint
);