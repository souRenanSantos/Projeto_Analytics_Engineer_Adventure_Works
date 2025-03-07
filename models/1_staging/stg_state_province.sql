with
    source_state_province as (
        select
            cast(STATEPROVINCEID as int) as pk_state_province
            , cast(STATEPROVINCECODE as string) as state_province_code
            , cast(coalesce(COUNTRYREGIONCODE, '0') as string) as country_region_code
            , cast(coalesce(NAME, 'N/A') as string) as state_province_name
            , cast(coalesce(TERRITORYID, 0) as int) as territory_id
        from {{ source('SNOWFLAKE', 'STATEPROVINCE') }}
    )

    , increment_zero_key as (
        select
            pk_state_province
            , state_province_code
            , country_region_code
            , state_province_name
            , territory_id
        from source_state_province
        union
        select
            0 as pk_state_province
            , 'N/A' as state_province_code
            , '0' as country_region_code
            , 'N/A' as state_province_name
            , 0 as territory_id
    )

    , add_surrogates_keys as (
        select
            {{ dbt_utils.generate_surrogate_key(['pk_state_province']) }} as sk_state_province
            , pk_state_province
            , {{ dbt_utils.generate_surrogate_key(['country_region_code']) }} as fk_country_region
            , {{ dbt_utils.generate_surrogate_key(['territory_id']) }} as fk_territory
            , state_province_code
            , state_province_name
        from increment_zero_key
    )

select *
from add_surrogates_keys