with
    source_sales_reason as (
        select
            cast(SALESREASONID as int) as pk_sales_reason
            , cast(NAME as string) as sales_reason
            , cast(REASONTYPE as string) as sales_reason_type
        from {{ source('SNOWFLAKE', 'SALESREASON') }}
    )

    , increment_zero_key as (
        select
            pk_sales_reason
            , sales_reason
            , sales_reason_type
        from source_sales_reason
        union
        select
            0 as pk_sales_reason
            , 'N/A' as sales_reason
            , 'N/A' as sales_reason_type
    )

    , add_surrogates_keys as (
        select
            {{ dbt_utils.generate_surrogate_key(['pk_sales_reason']) }} as sk_sales_reason
            , pk_sales_reason
            , sales_reason
            , sales_reason_type
        from increment_zero_key
    )

select *
from add_surrogates_keys