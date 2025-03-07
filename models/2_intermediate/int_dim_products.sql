with
    products as (
        select *
        from {{ ref('stg_product') }}
    )

    , models as (
        select *
        from {{ ref('stg_product_model') }}
    )

    , subcategorys as (
        select *
        from {{ ref('stg_product_subcategory') }}
    )

    , categorys as (
        select *
        from {{ ref('stg_product_category') }}
    )

    , joined as (
        select
            products.sk_product
            , products.product_name
            , models.product_model
            , subcategorys.product_subcategory
            , categorys.product_category
            , products.product_color
        from products
        left join models
            on models.sk_product_model = products.fk_product_model
        left join subcategorys
            on subcategorys.sk_product_subcategory = products.fk_product_subcategory
        left join categorys
            on categorys.sk_product_category = subcategorys.fk_product_category
    )

select *
from joined