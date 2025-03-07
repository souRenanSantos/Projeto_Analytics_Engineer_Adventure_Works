with
    customers as (
        select *
        from {{ ref('stg_customers') }}
    )

    , persons as (
        select *
        from {{ ref('stg_persons') }}
    )

    , stores as (
        select *
        from {{ ref('stg_store') }}
    )

    , territorys as (
        select *
        from {{ ref('stg_sales_territory') }}
    )

    , countrys as (
        select *
        from {{ ref('stg_country_region') }}
    )

    , joined as (
        select
            customers.sk_customer
            , persons.person_name as customer_name
            , stores.store_name
            , territorys.territory_name
            , countrys.country_name
            , countrys.country_code
        from customers
        left join persons
            on persons.sk_person = customers.fk_person
        left join stores
            on stores.sk_store = customers.fk_store
        left join territorys
            on territorys.sk_territory = customers.fk_territory
        left join countrys
            on countrys.sk_country = territorys.fk_country
    )

select *
from joined