with
    sellers as (
        select *
        from {{ ref('stg_sales_person') }}
    )

    , persons as (
        select *
        from {{ ref('stg_persons') }}
    )

    , employees as (
        select *
        from {{ ref('stg_employee') }}
    )

    , joined as (
        select
            sellers.sk_seller
            , persons.person_name as seller_name
            , employees.employee_job_title as seller_job_tittle
            , sellers.seller_sales_quota
            , sellers.seller_bonus
            , sellers.seller_commission_pct
        from sellers
        left join employees
            on employees.sk_employee = sellers.sk_seller
        left join persons
            on persons.sk_person = employees.sk_employee
    )

select *
from joined