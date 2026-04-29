# BigDataSnowflake — Лабораторная работа №1

## Анализ больших данных — нормализация данных в снежинку

## Описание работы

В рамках лабораторной работы реализована трансформация исходной модели данных в аналитическую модель «снежинка»/«звезда» на основе PostgreSQL.

Исходные данные представлены 10 CSV-файлами `mock_data`, содержащими информацию о покупателях, продавцах, магазинах, поставщиках и товарах для домашних питомцев.

В работе выполнены следующие этапы:

1. запуск PostgreSQL в Docker
2. загрузка исходных CSV-файлов в таблицу `public.mock_data`
3. создание таблиц фактов и измерений с помощью DDL-скрипта
4. заполнение таблиц фактов и измерений из исходной таблицы `mock_data` с помощью DML-скрипта
5. проверка построенной аналитической модели

## Цель работы

Цель работы — преобразовать исходные данные из файлов `mock_data(*).csv` в модель данных «снежинка»/«звезда» с использованием SQL-скриптов DDL и DML в PostgreSQL.

## Что реализовано

### 1. Исходный слой данных

Исходные CSV-файлы загружаются в таблицу:

- `public.mock_data`

После загрузки всех 10 файлов таблица содержит:

- `10000` строк

### 2. Аналитическая модель данных

На основе таблицы `public.mock_data` построены измерения и таблица фактов:

- `public.dim_customer`
- `public.dim_seller`
- `public.dim_product`
- `public.dim_store`
- `public.dim_supplier`
- `public.dim_date`
- `public.dim_brand`
- `public.dim_category`
- `public.dim_material`
- `public.dim_pet_category`
- `public.fact_sales`

### 3. SQL-скрипты

В проекте подготовлены:

- `load_mock_data.sql` — загрузка исходных CSV в `public.mock_data`
- `ddl.sql` — создание таблиц измерений и таблицы фактов
- `dml.sql` — заполнение таблиц измерений и таблицы фактов из `public.mock_data`

## Используемые технологии

- Docker
- Docker Compose
- PostgreSQL 15
- SQL
- DBeaver


## Описание файлов

### `docker-compose.yml`

Файл запуска PostgreSQL в Docker.

### `load_mock_data.sql`

SQL-скрипт создания и заполнения таблицы `public.mock_data` из 10 исходных CSV-файлов.

### `ddl.sql`

DDL-скрипт создания таблиц измерений и таблицы фактов для модели «снежинка»/«звезда».

### `dml.sql`

DML-скрипт заполнения таблиц измерений и таблицы фактов из таблицы `public.mock_data`.

### `исходные данные/`

Папка с 10 исходными CSV-файлами лабораторной работы.

## Описание источника данных

Используются 10 файлов:

- `MOCK_DATA (1).csv`
- `MOCK_DATA (2).csv`
- `MOCK_DATA (3).csv`
- `MOCK_DATA (4).csv`
- `MOCK_DATA (5).csv`
- `MOCK_DATA (6).csv`
- `MOCK_DATA (7).csv`
- `MOCK_DATA (8).csv`
- `MOCK_DATA (9).csv`
- `MOCK_DATA.csv`

Каждый файл содержит 1000 строк.

После загрузки всех файлов в PostgreSQL таблица `public.mock_data` содержит:

- `10000` строк

## Структура аналитической модели

### Измерения

- `dim_customer`
- `dim_seller`
- `dim_product`
- `dim_store`
- `dim_supplier`
- `dim_date`
- `dim_brand`
- `dim_category`
- `dim_material`
- `dim_pet_category`

### Факт

- `fact_sales`

### Схема модели (диаграмма снежинки)

```mermaid
erDiagram
    dim_customer {
        bigint customer_id PK
        text customer_first_name
        text customer_last_name
        bigint customer_age
        text customer_email
        text customer_country
        text customer_postal_code
        text customer_pet_type
        text customer_pet_name
        text customer_pet_breed
    }
    dim_seller {
        bigint seller_id PK
        text seller_first_name
        text seller_last_name
        text seller_email
        text seller_country
        text seller_postal_code
    }
    dim_product {
        bigint product_id PK
        text product_name
        numeric product_price
        bigint product_quantity
        numeric product_weight
        text product_color
        text product_size
        text product_description
        numeric product_rating
        bigint product_reviews
        date product_release_date
        date product_expiry_date
        bigint brand_id FK
        bigint category_id FK
        bigint material_id FK
        bigint pet_category_id FK
    }
    dim_brand {
        bigint brand_id PK
        text brand_name
    }
    dim_category {
        bigint category_id PK
        text category_name
    }
    dim_material {
        bigint material_id PK
        text material_name
    }
    dim_pet_category {
        bigint pet_category_id PK
        text pet_category_name
    }
    dim_store {
        bigint store_id PK
        text store_name
        text store_location
        text store_city
        text store_state
        text store_country
        text store_phone
        text store_email
    }
    dim_supplier {
        bigint supplier_id PK
        text supplier_name
        text supplier_contact
        text supplier_email
        text supplier_phone
        text supplier_address
        text supplier_city
        text supplier_country
    }
    dim_date {
        bigint date_id PK
        date full_date
        bigint year
        bigint month
        bigint day
        bigint quarter
    }
    fact_sales {
        bigint sale_id PK
        bigint customer_id FK
        bigint seller_id FK
        bigint product_id FK
        bigint store_id FK
        bigint supplier_id FK
        bigint date_id FK
        bigint sale_quantity
        numeric sale_total_price
        numeric product_price
        numeric product_rating
        bigint product_reviews
    }

    dim_customer ||--o{ fact_sales : "customer_id"
    dim_seller ||--o{ fact_sales : "seller_id"
    dim_product ||--o{ fact_sales : "product_id"
    dim_store ||--o{ fact_sales : "store_id"
    dim_supplier ||--o{ fact_sales : "supplier_id"
    dim_date ||--o{ fact_sales : "date_id"
    dim_brand ||--o{ dim_product : "brand_id"
    dim_category ||--o{ dim_product : "category_id"
    dim_material ||--o{ dim_product : "material_id"
    dim_pet_category ||--o{ dim_product : "pet_category_id"
## Логика модели

### `dim_customer`
Содержит данные о покупателях:
- идентификатор покупателя
- имя
- фамилию
- возраст
- email
- страну
- почтовый индекс
- тип питомца
- имя питомца
- породу питомца

### `dim_seller`
Содержит данные о продавцах:
- идентификатор продавца
- имя
- фамилию
- email
- страну
- почтовый индекс

### `dim_product`
Содержит данные о товарах:
- идентификатор товара
- название
- категорию
- цену
- количество
- категорию питомца
- вес
- цвет
- размер
- бренд
- материал
- описание
- рейтинг
- количество отзывов
- дату выпуска
- дату истечения срока

### `dim_store`
Содержит данные о магазинах:
- название магазина
- локацию
- город
- штат / регион
- страну
- телефон
- email

### `dim_supplier`
Содержит данные о поставщиках:
- название поставщика
- контактное лицо
- email
- телефон
- адрес
- город
- страну

### `dim_date`
Содержит календарное измерение:
- полную дату
- год
- месяц
- день
- квартал

### `fact_sales`
Содержит факты продаж:
- идентификатор продажи
- ссылки на измерения
- количество проданных единиц
- сумму продажи
- цену товара
- рейтинг товара
- количество отзывов

## Требования для запуска

Перед запуском необходимо установить:

- Docker Desktop
- DBeaver или другой SQL-клиент

## Параметры сервиса PostgreSQL

- контейнер: `postgres_snowflake_bd`
- база данных: `lab`
- пользователь: `user`
- пароль: `password`

## Важное замечание по PostgreSQL

Контейнерный PostgreSQL опубликован на внешнем порту:

- `5434`

Это сделано для исключения конфликта с другими локальными или контейнерными экземплярами PostgreSQL.

## Полная инструкция по воспроизведению лабораторной работы

### Шаг 1. Поднять контейнер PostgreSQL

    docker compose up -d

### Шаг 2. Проверить, что контейнер запущен

    docker ps

Должен быть запущен контейнер:

- `postgres_snowflake_bd`

### Шаг 3. Проверить подключение к PostgreSQL

    docker exec -it postgres_snowflake_bd psql -U user -d lab -c "\conninfo"

### Шаг 4. Загрузить исходные CSV в таблицу `public.mock_data`

    docker exec -i postgres_snowflake_bd psql -U user -d lab < load_mock_data.sql

### Шаг 5. Проверить, что `mock_data` загружена

    docker exec -it postgres_snowflake_bd psql -U user -d lab -c "select count(*) from public.mock_data;"

Ожидаемый результат:

    10000

### Шаг 6. Создать таблицы измерений и фактов

    docker exec -i postgres_snowflake_bd psql -U user -d lab < ddl.sql

### Шаг 7. Заполнить таблицы измерений и фактов

    docker exec -i postgres_snowflake_bd psql -U user -d lab < dml.sql

### Шаг 8. Проверить, что таблицы созданы

    docker exec -it postgres_snowflake_bd psql -U user -d lab -c "\dt public.*"

Должны существовать таблицы:

- `mock_data`
- `dim_customer`
- `dim_seller`
- `dim_product`
- `dim_store`
- `dim_supplier`
- `dim_date`
- `fact_sales`

### Шаг 9. Проверить количество строк

    docker exec -it postgres_snowflake_bd psql -U user -d lab -c "select count(*) from public.mock_data;"
    docker exec -it postgres_snowflake_bd psql -U user -d lab -c "select count(*) from public.dim_customer;"
    docker exec -it postgres_snowflake_bd psql -U user -d lab -c "select count(*) from public.dim_seller;"
    docker exec -it postgres_snowflake_bd psql -U user -d lab -c "select count(*) from public.dim_product;"
    docker exec -it postgres_snowflake_bd psql -U user -d lab -c "select count(*) from public.dim_store;"
    docker exec -it postgres_snowflake_bd psql -U user -d lab -c "select count(*) from public.dim_supplier;"
    docker exec -it postgres_snowflake_bd psql -U user -d lab -c "select count(*) from public.dim_date;"
    docker exec -it postgres_snowflake_bd psql -U user -d lab -c "select count(*) from public.fact_sales;"

## Примеры SQL-запросов для проверки результата

### 1. Проверка нескольких строк таблицы фактов

    select * from public.fact_sales limit 10;

### 2. Проверка нескольких строк измерения покупателей

    select * from public.dim_customer limit 10;

### 3. Проверка нескольких строк измерения товаров

    select * from public.dim_product limit 10;

### 4. Проверка нескольких строк измерения дат

    select * from public.dim_date limit 10;

### 5. Проверка связности факта и измерений

    select
        f.sale_id,
        c.customer_first_name,
        c.customer_last_name,
        p.product_name,
        f.sale_quantity,
        f.sale_total_price,
        d.full_date
    from public.fact_sales f
    left join public.dim_customer c on f.customer_id = c.customer_id
    left join public.dim_product p on f.product_id = p.product_id
    left join public.dim_date d on f.date_id = d.date_id
    limit 10;

## Порядок проверки лабораторной работы

Для проверки лабораторной работы необходимо выполнить следующие действия:

1. поднять PostgreSQL через `docker compose up -d`
2. загрузить 10 CSV-файлов в таблицу `public.mock_data`
3. убедиться, что `public.mock_data` содержит 10000 строк
4. выполнить `ddl.sql`
5. выполнить `dml.sql`
6. проверить, что таблицы измерений и факт созданы
7. проверить, что таблица `fact_sales` заполнена
8. выполнить контрольные SQL-запросы

## Что является результатом работы

В результате выполненной лабораторной работы подготовлен репозиторий, содержащий:

- исходные файлы `mock_data(*).csv`
- `docker-compose.yml` для запуска PostgreSQL
- SQL-скрипт загрузки исходных данных в `public.mock_data`
- DDL-скрипт создания таблиц фактов и измерений
- DML-скрипт заполнения таблиц фактов и измерений из исходных данных

## Итог

В работе реализована трансформация исходной модели данных в аналитическую модель снежинка/звезда в PostgreSQL.

Подготовлены:

- исходные CSV-файлы
- `docker-compose.yml`
- `load_mock_data.sql`
- `ddl.sql`
- `dml.sql`

Таким образом выполнены требования лабораторной работы №1 по дисциплине «Анализ больших данных».
