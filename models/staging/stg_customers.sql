with
    source_customers as (
        select
        cast(CUSTOMERID as int) as pk_customer
        , cast(coalesce(PERSONID, 0) as int) as person_id
        , cast(coalesce(STOREID, 0) as int) as store_id
        , cast(TERRITORYID as int) as territory_id
        from {{ source('SNOWFLAKE', 'CUSTOMER') }}
    )

    , add_surrogates_keys as (
        select
            {{ dbt_utils.generate_surrogate_key(['pk_customer']) }} as sk_customer
            , pk_customer
            , {{ dbt_utils.generate_surrogate_key(['person_id']) }} as fk_person
            , {{ dbt_utils.generate_surrogate_key(['store_id']) }} as fk_store
            , {{ dbt_utils.generate_surrogate_key(['territory_id']) }} as fk_territory
        from source_customers
    )

select *
from add_surrogates_keys