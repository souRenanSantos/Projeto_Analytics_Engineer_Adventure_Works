with
    address as (
        select *
        from {{ ref('stg_address') }}
    )

    , states as (
        select *
        from {{ ref('stg_state_province') }}
    )

    , countrys as (
        select *
        from {{ ref('stg_country_region') }}
    )

    , joined as (
        select
            address.sk_address
            , address.address_line_1
            , address.address_line_2
            , address.city_name
            , states.state_province_name
            , states.state_province_code
            , countrys.country_name
            , countrys.country_code
            , address.postal_code
            , address.spatial_location
        from address
        left join states
            on states.sk_state_province = address.fk_state_province
        left join countrys
            on countrys.sk_country = states.fk_country_region
    )

select *
from joined