with
    source_territory as (
        select
            cast(TERRITORYID as int) as pk_territory
            , cast(coalesce(COUNTRYREGIONCODE, '0') as string) as country_region_code
            , cast(NAME as string) as territory_name
        from {{ source('SNOWFLAKE', 'SALESTERRITORY') }}
    )

    , increment_zero_key as (
        select
            pk_territory
            , country_region_code
            , territory_name
        from source_territory
        union
        select
            0 as pk_territory
            , '0' as country_region_code
            , 'N/A' as territory_name
    )

    , add_surrogates_keys as (
        select
            {{ dbt_utils.generate_surrogate_key(['pk_territory']) }} as sk_territory
            , pk_territory
            , {{ dbt_utils.generate_surrogate_key(['country_region_code']) }} as fk_country
            , territory_name
        from increment_zero_key
    )

select *
from add_surrogates_keys