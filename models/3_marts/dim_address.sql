with
    dim_address as (
        select
            sk_address
            , address_line_1
            , address_line_2
            , city_name
            , state_province_name
            , state_province_code
            , country_name
            , country_code
            , postal_code
            , spatial_location
        from {{ ref('int_dim_address') }}
    )

select *
from dim_address