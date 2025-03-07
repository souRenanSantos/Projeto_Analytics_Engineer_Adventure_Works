with
    source_sales_order_detail as (
        select
            cast(SALESORDERDETAILID as int) as pk_order_detail
            , cast(SALESORDERID as int) as order_id
            , cast(PRODUCTID as int) as product_id
            , cast(ORDERQTY as int) as quantity
            , cast(UNITPRICE as decimal(10,2)) as unit_price
            , cast(UNITPRICEDISCOUNT as float) as discount_pct
        from {{ source('SNOWFLAKE', 'SALESORDERDETAIL') }}
    )

    , add_surrogates_keys as (
        select
            {{ dbt_utils.generate_surrogate_key(['pk_order_detail']) }} as sk_order_detail
            , pk_order_detail
            , {{ dbt_utils.generate_surrogate_key(['order_id']) }} as fk_order
            , {{ dbt_utils.generate_surrogate_key(['product_id']) }} as fk_product
            , quantity
            , unit_price
            , discount_pct
        from source_sales_order_detail
    )

select *
from add_surrogates_keys