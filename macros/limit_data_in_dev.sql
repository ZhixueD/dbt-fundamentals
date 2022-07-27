{% macro limit_data_in_days(column_name, days_before=3) %}

{% if target.name == 'dev' %}
where {{column_name}} >= DATE_SUB(current_date, interval {{days_before}} day)

{% endif %}
{% endmacro%}
