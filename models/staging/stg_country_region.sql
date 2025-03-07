with
    source_country_region as (
        select
            cast(COUNTRYREGIONCODE as string) as pk_country
            , cast(COUNTRYREGIONCODE as string) as country_code
            , cast(NAME as string) as country_name
        from {{ source('SNOWFLAKE', 'COUNTRYREGION') }}
    )

    , increment_zero_key as (
        select
            pk_country
            , country_code
            , country_name
        from source_country_region
        union
        select
            '0' as pk_country
            , 'N/A' as country_code
            , 'N/A' as country_name
    )

    , add_surrogates_keys as (
        select
            {{ dbt_utils.generate_surrogate_key(['pk_country']) }} as sk_country
            , pk_country
            , country_code
            , country_name
        from increment_zero_key
    )

select *
from add_surrogates_keys