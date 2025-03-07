with
    source_sales_person as (
        select
            cast(BUSINESSENTITYID as int) as pk_seller
            , cast(coalesce(TERRITORYID, 0) as int) as territory_id
            , cast(SALESQUOTA as decimal(18,2)) as seller_sales_quota
            , cast(BONUS as decimal(18,2)) as seller_bonus
            , cast(COMMISSIONPCT as float) as seller_commission_pct
        from {{ source('SNOWFLAKE', 'SALESPERSON') }}
    )

    , increment_zero_key as (
        select
            pk_seller
            , territory_id
            , seller_sales_quota
            , seller_bonus
            , seller_commission_pct
        from source_sales_person
        union
        select
            0 as pk_seller
            , 0 as territory_id
            , null as seller_sales_quota
            , 0 as seller_bonus
            , 0 as seller_commission_pct
    )

    , add_surrogates_keys as (
        select
            {{ dbt_utils.generate_surrogate_key(['pk_seller']) }} as sk_seller
            , pk_seller
            , {{ dbt_utils.generate_surrogate_key(['territory_id']) }} as fk_territory
            , seller_sales_quota
            , seller_bonus
            , seller_commission_pct
        from increment_zero_key
    )

select *
from add_surrogates_keys