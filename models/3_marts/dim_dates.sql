with
    dim_dates as (
        select
            sk_date
            , date_day
            , year_num
            , year_abv
            , quarter_num
            , quarter_year
            , year_quarter_int
            , month_num
            , month_name
            , month_abv
            , month_year
            , year_month_int
            , day_num
            , weekday
            , weekday_name
            , weekday_abv
            , week_year
        from {{ ref('int_dim_dates') }}
    )

select *
from dim_dates