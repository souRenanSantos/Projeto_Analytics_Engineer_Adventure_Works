with
    orders as (
        select *
        from {{ ref('stg_sales_order_header') }}
    )

    , orders_details as (
        select *
        from {{ ref('stg_sales_order_detail') }}
    )

    , sellers as (
        select *
        from {{ ref('stg_sales_person') }}
    )

    , credit_card as (
        select *
        from {{ ref('stg_credit_card') }}
    )
    
    , sales_reason as (
        select *
        from {{ ref('stg_sales_reason') }}
    )

    , sales_order_reason as (
        select
            fk_order
            , fk_sales_reason
            , row_number() over (partition by fk_order order by modified_date desc) as row_num
        from {{ ref('stg_sales_order_header_sales_reason') }}
    )

    , filtered_sales_order_reason as (
        select
            fk_order
            , fk_sales_reason
        from sales_order_reason
        where row_num = 1
    )

    , joined as (
        select
            orders_details.sk_order_detail
            , orders.fk_customer
            , orders_details.fk_product
            , orders.fk_seller
            , orders.fk_ship_address
            , orders.fk_bill_address
            , orders.fk_order_date
            , orders.fk_ship_date
            , orders_details.quantity
            , orders_details.unit_price
            , orders_details.discount_pct
            , orders.freight
            , seller_commission_pct
            , orders.order_id
            , coalesce(sales_reason.sales_reason, 'N/A') as sales_reason
            , coalesce(sales_reason.sales_reason_type, 'N/A') as sales_reason_type
            , credit_card.credit_card_type
            , orders.is_online
        from orders_details
        left join orders
            on orders.sk_order = orders_details.fk_order
        left join filtered_sales_order_reason
            on filtered_sales_order_reason.fk_order = orders.sk_order
        left join sales_reason
            on sales_reason.sk_sales_reason = filtered_sales_order_reason.fk_sales_reason
        left join sellers
            on sellers.sk_seller = orders.fk_seller
        left join credit_card
            on credit_card.sk_credit_card = orders.fk_credit_card
    )

    , add_metrics as (
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
            , cast(unit_price*quantity as decimal(18,6)) as subtotal_value
            , cast(subtotal_value*discount_pct as decimal(18,6)) as discount_value
            , cast(subtotal_value-discount_value as decimal(18,6)) as subtotal_ned_value
            , cast(
                subtotal_ned_value/(
                    SUM(subtotal_ned_value) over (partition by order_id)
                )*freight as decimal(18,6)
            ) as freight_apportionment
            , cast(subtotal_ned_value+freight_apportionment as decimal(18,6)) as subtotal_order
            , cast(subtotal_ned_value*seller_commission_pct as decimal(18,6)) as seller_commission
            , order_id
            , sales_reason
            , sales_reason_type
            , credit_card_type
            , is_online
        from joined
    )

select *
from add_metrics