
with
    source_person as (
        select
            cast(BUSINESSENTITYID as int) as pk_person
            , FIRSTNAME || ' ' || LASTNAME as person_name
        from {{ source('SNOWFLAKE', 'PERSON') }}
    )

    , increment_zero_key as (
        select
            pk_person
            , person_name
        from source_person
        union
        select
            0 as pk_person
            , 'N/A' as person_name
    )

    , add_surrogate_key as (
        select
            {{ dbt_utils.generate_surrogate_key(['pk_person']) }} as sk_person
            , pk_person
            , person_name
        from increment_zero_key
    )

select *
from add_surrogate_key