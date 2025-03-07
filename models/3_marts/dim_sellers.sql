with
    dim_sellers as (
        select
            sk_seller
            , seller_name
            , seller_job_tittle
            , seller_sales_quota
            , seller_bonus
            , seller_commission_pct
        from {{ ref('int_dim_sellers') }}
    )

select *
from dim_sellers