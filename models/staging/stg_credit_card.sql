with
    source_credit_card as (
        select
            cast(CREDITCARDID as int) as pk_credit_card
            , cast(CARDTYPE as string) as credit_card_type
        from {{ source('SNOWFLAKE', 'CREDITCARD') }}
    )

    , increment_zero_key as (
        select
            pk_credit_card
            , credit_card_type
        from source_credit_card
        union
        select
            0 as pk_credit_card
            , 'N/A' as credit_card_type
    )

    , add_surrogates_keys as (
        select
            {{ dbt_utils.generate_surrogate_key(['pk_credit_card']) }} as sk_credit_card
            , pk_credit_card
            , credit_card_type
        from increment_zero_key
    )

select *
from add_surrogates_keys