truncate table public.fact_sales restart identity cascade;
truncate table public.dim_date restart identity cascade;
truncate table public.dim_supplier restart identity cascade;
truncate table public.dim_store restart identity cascade;
truncate table public.dim_product restart identity cascade;
truncate table public.dim_seller restart identity cascade;
truncate table public.dim_customer restart identity cascade;

insert into public.dim_customer (
    customer_id,
    customer_first_name,
    customer_last_name,
    customer_age,
    customer_email,
    customer_country,
    customer_postal_code,
    customer_pet_type,
    customer_pet_name,
    customer_pet_breed
)
select distinct on (sale_customer_id::bigint)
    sale_customer_id::bigint,
    customer_first_name,
    customer_last_name,
    customer_age::bigint,
    customer_email,
    customer_country,
    customer_postal_code,
    customer_pet_type,
    customer_pet_name,
    customer_pet_breed
from public.mock_data
where sale_customer_id is not null
order by sale_customer_id::bigint, id::bigint;

insert into public.dim_seller (
    seller_id,
    seller_first_name,
    seller_last_name,
    seller_email,
    seller_country,
    seller_postal_code
)
select distinct on (sale_seller_id::bigint)
    sale_seller_id::bigint,
    seller_first_name,
    seller_last_name,
    seller_email,
    seller_country,
    seller_postal_code
from public.mock_data
where sale_seller_id is not null
order by sale_seller_id::bigint, id::bigint;

insert into public.dim_product (
    product_id,
    product_name,
    product_category,
    product_price,
    product_quantity,
    pet_category,
    product_weight,
    product_color,
    product_size,
    product_brand,
    product_material,
    product_description,
    product_rating,
    product_reviews,
    product_release_date,
    product_expiry_date
)
select distinct on (sale_product_id::bigint)
    sale_product_id::bigint,
    product_name,
    product_category,
    product_price::numeric(18,2),
    product_quantity::bigint,
    pet_category,
    product_weight::numeric(18,2),
    product_color,
    product_size,
    product_brand,
    product_material,
    product_description,
    product_rating::numeric(18,2),
    product_reviews::bigint,
    product_release_date::date,
    product_expiry_date::date
from public.mock_data
where sale_product_id is not null
order by sale_product_id::bigint, id::bigint;

insert into public.dim_store (
    store_name,
    store_location,
    store_city,
    store_state,
    store_country,
    store_phone,
    store_email
)
select distinct
    store_name,
    store_location,
    store_city,
    store_state,
    store_country,
    store_phone,
    store_email
from public.mock_data;

insert into public.dim_supplier (
    supplier_name,
    supplier_contact,
    supplier_email,
    supplier_phone,
    supplier_address,
    supplier_city,
    supplier_country
)
select distinct
    supplier_name,
    supplier_contact,
    supplier_email,
    supplier_phone,
    supplier_address,
    supplier_city,
    supplier_country
from public.mock_data;

insert into public.dim_date (
    full_date,
    year,
    month,
    day,
    quarter
)
select distinct
    sale_date::date,
    extract(year from sale_date::date)::bigint,
    extract(month from sale_date::date)::bigint,
    extract(day from sale_date::date)::bigint,
    extract(quarter from sale_date::date)::bigint
from public.mock_data
where sale_date is not null;

insert into public.fact_sales (
    sale_id,
    customer_id,
    seller_id,
    product_id,
    store_id,
    supplier_id,
    date_id,
    sale_quantity,
    sale_total_price,
    product_price,
    product_rating,
    product_reviews
)
select distinct on (m.id::bigint)
    m.id::bigint as sale_id,
    m.sale_customer_id::bigint as customer_id,
    m.sale_seller_id::bigint as seller_id,
    m.sale_product_id::bigint as product_id,
    ds.store_id,
    dsp.supplier_id,
    dd.date_id,
    m.sale_quantity::bigint,
    m.sale_total_price::numeric(18,2),
    m.product_price::numeric(18,2),
    m.product_rating::numeric(18,2),
    m.product_reviews::bigint
from public.mock_data m
left join public.dim_store ds
    on m.store_name = ds.store_name
   and m.store_location = ds.store_location
   and m.store_city = ds.store_city
   and m.store_state = ds.store_state
   and m.store_country = ds.store_country
   and m.store_phone = ds.store_phone
   and m.store_email = ds.store_email
left join public.dim_supplier dsp
    on m.supplier_name = dsp.supplier_name
   and m.supplier_contact = dsp.supplier_contact
   and m.supplier_email = dsp.supplier_email
   and m.supplier_phone = dsp.supplier_phone
   and m.supplier_address = dsp.supplier_address
   and m.supplier_city = dsp.supplier_city
   and m.supplier_country = dsp.supplier_country
left join public.dim_date dd
    on m.sale_date::date = dd.full_date
where m.id is not null
order by m.id::bigint, m.sale_customer_id::bigint nulls last;