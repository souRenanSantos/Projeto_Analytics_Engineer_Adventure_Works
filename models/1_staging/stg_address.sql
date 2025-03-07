with
    source_address as (
        select
            cast(ADDRESSID as int) as pk_address
            , cast(STATEPROVINCEID as int) as state_province_id
            , cast(ADDRESSLINE1 as string) as address_line_1
            , cast(coalesce(ADDRESSLINE2, 'N/A') as string) as address_line_2
            , cast(CITY as string) as city_name
            , cast(POSTALCODE as string) as postal_code
            , cast(SPATIALLOCATION as string) as spatial_location
        from {{ source('SNOWFLAKE', 'ADDRESS') }}
    )

    , increment_zero_key as (
        select
            pk_address
            , state_province_id
            , address_line_1
            , address_line_2
            , city_name
            , postal_code
            , spatial_location
        from source_address
        union
        select
            0 as pk_address
            , 0 as state_province_id
            , 'N/A' as address_line_1
            , 'N/A' as address_line_2
            , 'N/A' as city_name
            , 'N/A' as postal_code
            , 'N/A' as spatial_location
    )

    , add_surrogates_keys as (
        select
            {{ dbt_utils.generate_surrogate_key(['pk_address']) }} as sk_address
            , pk_address
            , {{ dbt_utils.generate_surrogate_key(['state_province_id']) }} as fk_state_province
            , address_line_1
            , address_line_2
            , city_name
            , postal_code
            , spatial_location
        from increment_zero_key
    )

select *
from add_surrogates_keys