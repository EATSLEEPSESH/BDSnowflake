TRUNCATE TABLE
public.fact_sales,
public.dim_product,
public.dim_brand,
public.dim_category,
public.dim_material,
public.dim_pet_category,
public.dim_date,
public.dim_supplier,
public.dim_store,
public.dim_seller,
public.dim_customer
RESTART IDENTITY CASCADE;

INSERT INTO public.dim_brand (brand_name)
SELECT DISTINCT product_brand
FROM public.mock_data
WHERE product_brand IS NOT NULL
ON CONFLICT (brand_name) DO NOTHING;

INSERT INTO public.dim_category (category_name)
SELECT DISTINCT product_category
FROM public.mock_data
WHERE product_category IS NOT NULL
ON CONFLICT (category_name) DO NOTHING;

INSERT INTO public.dim_material (material_name)
SELECT DISTINCT product_material
FROM public.mock_data
WHERE product_material IS NOT NULL
ON CONFLICT (material_name) DO NOTHING;

INSERT INTO public.dim_pet_category (pet_category_name)
SELECT DISTINCT pet_category
FROM public.mock_data
WHERE pet_category IS NOT NULL
ON CONFLICT (pet_category_name) DO NOTHING;

INSERT INTO public.dim_customer (
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
SELECT DISTINCT ON (sale_customer_id::bigint)
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
FROM public.mock_data
WHERE sale_customer_id IS NOT NULL
ORDER BY sale_customer_id::bigint, id::bigint
ON CONFLICT (customer_id) DO NOTHING;

INSERT INTO public.dim_seller (
    seller_id,
    seller_first_name,
    seller_last_name,
    seller_email,
    seller_country,
    seller_postal_code
)
SELECT DISTINCT ON (sale_seller_id::bigint)
    sale_seller_id::bigint,
    seller_first_name,
    seller_last_name,
    seller_email,
    seller_country,
    seller_postal_code
FROM public.mock_data
WHERE sale_seller_id IS NOT NULL
ORDER BY sale_seller_id::bigint, id::bigint
ON CONFLICT (seller_id) DO NOTHING;

INSERT INTO public.dim_store (
    store_name,
    store_location,
    store_city,
    store_state,
    store_country,
    store_phone,
    store_email
)
SELECT DISTINCT
    store_name,
    store_location,
    store_city,
    store_state,
    store_country,
    store_phone,
    store_email
FROM public.mock_data
ON CONFLICT DO NOTHING;

INSERT INTO public.dim_supplier (
    supplier_name,
    supplier_contact,
    supplier_email,
    supplier_phone,
    supplier_address,
    supplier_city,
    supplier_country
)
SELECT DISTINCT
    supplier_name,
    supplier_contact,
    supplier_email,
    supplier_phone,
    supplier_address,
    supplier_city,
    supplier_country
FROM public.mock_data
ON CONFLICT DO NOTHING;

INSERT INTO public.dim_date (
    full_date,
    year,
    month,
    day,
    quarter
)
SELECT DISTINCT
    sale_date::date,
    EXTRACT(YEAR FROM sale_date::date)::bigint,
    EXTRACT(MONTH FROM sale_date::date)::bigint,
    EXTRACT(DAY FROM sale_date::date)::bigint,
    EXTRACT(QUARTER FROM sale_date::date)::bigint
FROM public.mock_data
WHERE sale_date IS NOT NULL
ON CONFLICT (full_date) DO NOTHING;

INSERT INTO public.dim_product (
    product_id,
    product_name,
    product_price,
    product_quantity,
    product_weight,
    product_color,
    product_size,
    product_description,
    product_rating,
    product_reviews,
    product_release_date,
    product_expiry_date,
    brand_id,
    category_id,
    material_id,
    pet_category_id
)
SELECT DISTINCT ON (m.sale_product_id::bigint)
    m.sale_product_id::bigint,
    m.product_name,
    m.product_price::numeric(18,2),
    m.product_quantity::bigint,
    m.product_weight::numeric(18,2),
    m.product_color,
    m.product_size,
    m.product_description,
    m.product_rating::numeric(18,2),
    m.product_reviews::bigint,
    m.product_release_date::date,
    m.product_expiry_date::date,
    b.brand_id,
    c.category_id,
    mtr.material_id,
    pc.pet_category_id
FROM public.mock_data m
LEFT JOIN public.dim_brand b ON m.product_brand = b.brand_name
LEFT JOIN public.dim_category c ON m.product_category = c.category_name
LEFT JOIN public.dim_material mtr ON m.product_material = mtr.material_name
LEFT JOIN public.dim_pet_category pc ON m.pet_category = pc.pet_category_name
WHERE m.sale_product_id IS NOT NULL
ORDER BY m.sale_product_id::bigint, m.id::bigint
ON CONFLICT (product_id) DO NOTHING;

INSERT INTO public.fact_sales (
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
SELECT
    m.id::bigint,
    m.sale_customer_id::bigint,
    m.sale_seller_id::bigint,
    m.sale_product_id::bigint,
    ds.store_id,
    dsp.supplier_id,
    dd.date_id,
    m.sale_quantity::bigint,
    m.sale_total_price::numeric(18,2),
    m.product_price::numeric(18,2),
    m.product_rating::numeric(18,2),
    m.product_reviews::bigint
FROM public.mock_data m
LEFT JOIN public.dim_store ds
    ON m.store_name = ds.store_name
   AND m.store_location = ds.store_location
   AND m.store_city = ds.store_city
   AND m.store_state = ds.store_state
   AND m.store_country = ds.store_country
   AND m.store_phone = ds.store_phone
   AND m.store_email = ds.store_email
LEFT JOIN public.dim_supplier dsp
    ON m.supplier_name = dsp.supplier_name
   AND m.supplier_contact = dsp.supplier_contact
   AND m.supplier_email = dsp.supplier_email
   AND m.supplier_phone = dsp.supplier_phone
   AND m.supplier_address = dsp.supplier_address
   AND m.supplier_city = dsp.supplier_city
   AND m.supplier_country = dsp.supplier_country
LEFT JOIN public.dim_date dd
    ON m.sale_date::date = dd.full_date
ON CONFLICT (sale_id) DO NOTHING;
