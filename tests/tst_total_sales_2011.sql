with
    int_orders_details as (
        select *
        from {{ ref('int_fact_orders_details') }}
    )

    , int_dim_dates as (
        select *
        from {{ ref('int_dim_dates') }}
    )

    , joined as (
        select
            int_orders_details.order_id
            , int_dim_dates.date_day as order_date
            , int_orders_details.subtotal_value
        from int_orders_details
        left join int_dim_dates
            on int_orders_details.fk_order_date = int_dim_dates.sk_date
    )

    , total_sales_2011 as (
        select sum(subtotal_value) as total_sales
        from joined
        where order_date between '2011-01-01' and '2011-12-31'
    )

select total_sales
from total_sales_2011
where total_sales not between 12646112.00 and 12646113.00