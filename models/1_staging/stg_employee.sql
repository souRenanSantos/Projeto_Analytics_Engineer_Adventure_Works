with
    source_employee as (
        select
            cast(BUSINESSENTITYID as int) as pk_employee
            , cast(JOBTITLE as string) as employee_job_title
        from {{ source('SNOWFLAKE', 'EMPLOYEE') }}
    )

    , increment_zero_key as (
        select
            pk_employee
            , employee_job_title
        from source_employee
        union
        select
            0 as pk_employee
            , 'N/A' as employee_job_title
    )

    , add_surrogates_keys as (
        select
            {{ dbt_utils.generate_surrogate_key(['pk_employee']) }} as sk_employee
            , pk_employee
            , employee_job_title
        from increment_zero_key
    )

select *
from add_surrogates_keys