with
    fact_orders_details as (
        select
            sk_order_detail
            , fk_customer
            , fk_product
            , fk_seller
            , fk_ship_address
            , fk_bill_address
            , fk_order_date
            , fk_ship_date
            , quantity
            , unit_price
            , discount_pct
            , subtotal_value
            , discount_value
            , subtotal_ned_value
            , freight_apportionment
            , subtotal_order
            , seller_commission
            , order_id
            , sales_reason
            , sales_reason_type
            , credit_card_type
            , is_online
        from {{ ref('int_fact_orders_details') }}
    )

select *
from fact_orders_details