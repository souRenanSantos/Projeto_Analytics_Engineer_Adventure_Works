with
    source_product_subcategory as (
        select
            cast(PRODUCTSUBCATEGORYID as int) as pk_product_subcategory
            , cast(coalesce(PRODUCTCATEGORYID, 0) as int) as product_category_id
            , cast(NAME as string) as product_subcategory
        from {{ source('SNOWFLAKE', 'PRODUCTSUBCATEGORY') }}
    )

    , increment_zero_key as (
        select
            pk_product_subcategory
            , product_category_id
            , product_subcategory
        from source_product_subcategory
        union
        select
            0 as pk_product_subcategory
            , 0 as product_category_id
            , 'N/A' as product_subcategory
    )

    , add_surrogates_keys as (
        select
            {{ dbt_utils.generate_surrogate_key(['pk_product_subcategory']) }} as sk_product_subcategory
            , pk_product_subcategory
            , {{ dbt_utils.generate_surrogate_key(['product_category_id']) }} as fk_product_category
            , product_subcategory
        from increment_zero_key
    )

select *
from add_surrogates_keys