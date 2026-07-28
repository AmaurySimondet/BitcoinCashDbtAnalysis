{{ config(
    materialized='table',
    partition_by={
      "field": "block_timestamp",
      "data_type": "timestamp",
      "granularity": "day"
    },
    cluster_by=["is_coinbase"]
) }}

-- Last three months of available Bitcoin Cash transactions.
-- The public dataset crypto_bitcoin_cash stopped ingesting around 2024-05-13,
-- so the window is relative to MAX(block_timestamp), not CURRENT_DATE().

with source_bounds as (
    select max(block_timestamp) as max_block_timestamp
    from {{ source('crypto_bitcoin_cash', 'transactions') }}
),

window_start as (
    select
        max_block_timestamp,
        timestamp(date_sub(date(max_block_timestamp), interval 3 month)) as start_timestamp,
        date_trunc(
            date_sub(date(max_block_timestamp), interval 3 month),
            month
        ) as start_month
    from source_bounds
)

select
    `hash` as transaction_hash,
    `size`,
    virtual_size,
    `version`,
    lock_time,
    block_number,
    block_hash,
    block_timestamp,
    block_timestamp_month,
    is_coinbase,
    inputs,
    outputs,
    input_count,
    output_count,
    input_value,
    output_value,
    fee
from {{ source('crypto_bitcoin_cash', 'transactions') }} as tx
cross join window_start as w
-- block_timestamp_month enables partition pruning on the source table;
-- block_timestamp then trims to the exact 3-month boundary.
where tx.block_timestamp_month >= w.start_month
  and tx.block_timestamp >= w.start_timestamp
  and tx.block_timestamp <= w.max_block_timestamp
