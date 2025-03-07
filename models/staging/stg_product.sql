with
    source_product as (
        select
            cast(PRODUCTID as int) as pk_product
            , cast(coalesce(PRODUCTSUBCATEGORYID, 0) as int) as product_subcategory_id 
            , cast(coalesce(PRODUCTMODELID, 0) as int) as product_model_id
            , cast(NAME as string) as product_name
            , cast(coalesce(COLOR, 'N/A') as string) as product_color
        from {{ source('SNOWFLAKE', 'PRODUCT') }}
    )

    , increment_zero_key as (
        select
            pk_product
            , product_subcategory_id
            , product_model_id
            , product_name
            , product_color
        from source_product
        union
        select
            0 as pk_product
            , 0 as product_subcategory_id
            , 0 as product_model_id
            , 'N/A' as product_name
            , 'N/A' as product_color
    )

    , add_surrogates_keys as (
        select
            {{ dbt_utils.generate_surrogate_key(['pk_product']) }} as sk_product
            , pk_product
            , {{ dbt_utils.generate_surrogate_key(['product_subcategory_id']) }} as sk_product_subcategory
            , {{ dbt_utils.generate_surrogate_key(['product_model_id']) }} as sk_product_model
            , product_name
            , product_color
        from increment_zero_key
    )

select *
from add_surrogates_keys