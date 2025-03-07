with
    dim_customers as (
        select
            sk_customer
            , customer_name
            , store_name
            , territory_name
            , country_name
            , country_code
        from {{ ref('int_dim_customers') }}
    )

select *
from dim_customers