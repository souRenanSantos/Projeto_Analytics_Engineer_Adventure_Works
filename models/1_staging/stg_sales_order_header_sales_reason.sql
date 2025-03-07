with
    source_sales_order_header_sales_reason as (
        select
            cast(SALESORDERID as int) as order_id
            , cast(coalesce(SALESREASONID, 0) as int) as sales_reason_id
        from {{ source('SNOWFLAKE', 'SALESORDERHEADERSALESREASON') }}
    )

    , add_surrogates_keys as (
        select
            {{ dbt_utils.generate_surrogate_key(['order_id']) }} as fk_order
            , {{ dbt_utils.generate_surrogate_key(['sales_reason_id']) }} as fk_sales_reason
        from source_sales_order_header_sales_reason
    )

select *
from add_surrogates_keys