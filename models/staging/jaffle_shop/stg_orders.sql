with orders as (

    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status

    from {{source('jaffle_shop', 'orders')}}

    {{ limit_data_in_days('order_date', 1600) }}

)

select * from orders order by order_date
