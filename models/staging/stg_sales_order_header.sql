with
    source_sales_order_header as (
        select
            cast(SALESORDERID as int) as pk_order
            , cast(coalesce(CUSTOMERID, 0) as int) as customer_id
            , cast(coalesce(SALESPERSONID, 0) as int) as seller_id
            , cast(coalesce(TERRITORYID, 0) as int) as territory_id
            , cast(coalesce(BILLTOADDRESSID, 0) as int) as bill_address_id
            , cast(coalesce(SHIPTOADDRESSID, 0) as int) as ship_address_id
            , cast(coalesce(CREDITCARDID, 0) as int) as credit_card_id
            , cast(coalesce(ORDERDATE, '0') as date) as order_date
            , cast(coalesce(SHIPDATE, '0') as date) as ship_date
            , cast(FREIGHT as decimal(10,2)) as freight
            , cast(SALESORDERID as int) as order_id
            , cast(ONLINEORDERFLAG as boolean) as is_online
        from {{ source('SNOWFLAKE', 'SALESORDERHEADER') }}
    )

    , add_surrogates_keys as (
        select
            {{ dbt_utils.generate_surrogate_key(['pk_order']) }} as sk_order
            , pk_order
            , {{ dbt_utils.generate_surrogate_key(['customer_id']) }} as fk_customer
            , {{ dbt_utils.generate_surrogate_key(['seller_id']) }} as fk_seller
            , {{ dbt_utils.generate_surrogate_key(['territory_id']) }} as fk_territory
            , {{ dbt_utils.generate_surrogate_key(['bill_address_id']) }} as fk_bill_address
            , {{ dbt_utils.generate_surrogate_key(['ship_address_id']) }} as fk_ship_address
            , {{ dbt_utils.generate_surrogate_key(['credit_card_id']) }} as fk_credit_card
            , {{ dbt_utils.generate_surrogate_key(['order_date']) }} as fk_order_date
            , {{ dbt_utils.generate_surrogate_key(['ship_date']) }} as fk_ship_date
            , freight
            , order_id
            , is_online
        from source_sales_order_header
    )

select *
from add_surrogates_keys