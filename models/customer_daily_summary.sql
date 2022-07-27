select
    {{ dbt_utils.surrogate_key(['customer_id','order_date'])}} as id,
    customer_id,
    order_date,
    count(*) as num

from {{ ref('stg_orders') }}
group by 1,2,3
order by order_date, customer_id