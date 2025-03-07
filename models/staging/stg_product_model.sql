with
    source_product_model as (
        select
            cast(PRODUCTMODELID as int) as pk_product_model
            , cast(NAME as string) as product_model
        from {{ source('SNOWFLAKE', 'PRODUCTMODEL') }}
    )

    , increment_zero_key as (
        select
            pk_product_model
            , product_model
        from source_product_model
        union
        select
            0 as pk_product_model
            , 'N/A' as product_model
    )

    , add_surrogates_keys as (
        select
            {{ dbt_utils.generate_surrogate_key(['pk_product_model']) }} as sk_product_model
            , pk_product_model
            , product_model
        from increment_zero_key
    )

select *
from add_surrogates_keys