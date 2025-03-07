with
    dim_products as (
        select
            sk_product
            , product_name
            , product_model
            , product_subcategory
            , product_category
            , product_color
        from {{ ref('int_dim_products') }}
    )

select *
from dim_products