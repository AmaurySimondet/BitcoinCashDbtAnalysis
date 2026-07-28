{{ config(materialized='table') }}

-- Current address balances over the staging window (last 3 months),
-- excluding any address that participated in at least one coinbase tx.

with coinbase_addresses as (
    select distinct address
    from {{ ref('stg_transactions') }} as tx
    cross join unnest(tx.outputs) as output
    cross join unnest(output.addresses) as address
    where tx.is_coinbase
      and address is not null
      and address != ''
),

double_entry as (
    -- Credits (outputs received)
    select
        address,
        output.value as value
    from {{ ref('stg_transactions') }} as tx
    cross join unnest(tx.outputs) as output
    cross join unnest(output.addresses) as address
    where address is not null
      and address != ''

    union all

    -- Debits (inputs spent)
    select
        address,
        -input.value as value
    from {{ ref('stg_transactions') }} as tx
    cross join unnest(tx.inputs) as input
    cross join unnest(input.addresses) as address
    where address is not null
      and address != ''
),

balances as (
    select
        address,
        sum(value) as balance
    from double_entry
    group by address
)

select
    b.address,
    b.balance
from balances as b
left join coinbase_addresses as c
    on b.address = c.address
where c.address is null
