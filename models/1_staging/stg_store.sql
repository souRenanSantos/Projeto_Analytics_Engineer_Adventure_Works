with
    source_store as (
        select
            cast(BUSINESSENTITYID as int) as pk_store
            , cast(NAME as string) as store_name
        from {{ source('SNOWFLAKE', 'STORE') }}
    )

    , increment_zero_key as (
        select
            pk_store
            , store_name
        from source_store
        union
        select
            0 as pk_store
            , 'N/A' as store_name
    )

    , add_surrogate_key as (
        select
            {{ dbt_utils.generate_surrogate_key(['pk_store']) }} as sk_store
            , pk_store
            , store_name
        from increment_zero_key
    )

select *
from add_surrogate_key