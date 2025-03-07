with
    source_product_category as (
        select
            cast(PRODUCTCATEGORYID as int) as pk_product_category
            , cast(NAME as string) as product_category
        from {{ source('SNOWFLAKE', 'PRODUCTCATEGORY') }}
    )

    , increment_zero_key as (
        select
            pk_product_category
            , product_category
        from source_product_category
        union
        select
            0 as pk_product_category
            , 'N/A' as product_category
    )

    , add_surrogates_keys as (
        select
            {{ dbt_utils.generate_surrogate_key(['pk_product_category']) }} as sk_product_category
            , pk_product_category
            , product_category
        from increment_zero_key
    )

select *
from add_surrogates_keys