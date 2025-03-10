with
    generate_dates as (
        {% set query_min_date %}
            select min(order_date)
            from {{ ref('stg_sales_order_header') }}
        {% endset %}

        {% set query_max_date %}
            select max(ship_date)
            from {{ ref('stg_sales_order_header') }}
        {% endset %}

        {%- set min_date = dbt_utils.get_single_value(query_min_date) -%}

        {%- set max_date = dbt_utils.get_single_value(query_max_date) -%}

        {{ dbt_date.get_date_dimension(start_date=min_date, end_date=max_date) }}
    )

    , select_columns as (
        select
            cast(date_day as date) as date_day
            , cast(year_number as int) as year_num
            , cast(quarter_of_year as int) as quarter_num
            , cast(month_of_year as int) as month_num
            , month_name
            , month_name_short as month_abv
            , cast(day_of_month as int) as day_num
            , cast(day_of_week as int) as weekday
            , day_of_week_name as weekday_name
            , day_of_week_name_short as weekday_abv
            , cast(week_of_year as int) as week_year
        from generate_dates
    )

    , add_new_columns as (
        select
            {{ dbt_utils.generate_surrogate_key(['date_day']) }} as sk_date
            , date_day
            , year_num
            , substring(year_num, len(year_num)-1, 2) as year_abv
            , quarter_num
            , 'Q' || quarter_num || '-' || year_abv as quarter_year
            , cast(year_num*100+quarter_num as int) as year_quarter_int
            , month_num
            , month_name
            , month_abv
            , month_abv || '-' || year_abv as month_year
            , cast(year_num*100+month_num as int) as year_month_int
            , day_num
            , weekday
            , weekday_name
            , weekday_abv
            , week_year
        from select_columns
    )

select *
from add_new_columns