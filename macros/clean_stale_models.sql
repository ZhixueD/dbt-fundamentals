{#  
    -- let's develop a macro that 
    1. queries the information schema of a database
    2. finds objects that are > 1 week old (no longer maintained)
    3. generates automated drop statements
    4. has the ability to execute those drop statements

#}

{% macro clean_stale_models(schema=target.schema, days=1, dry_run=True) %}
    
    {% set get_drop_commands_query %}
        select drop_type, 'DROP ' || drop_type || ' ' || table_schema || '.' || table_name || ';' from 
        (select *,
            case 
                when table_type = 'VIEW'
                    then table_type
                else 
                    'TABLE'
            end as drop_type 
            
        from {{ schema }}.INFORMATION_SCHEMA.TABLES 
        where date(creation_time) <= current_date - {{ days }})
    {% endset %}

    {% if execute %}
        {{ log('\nGenerating cleanup queries...\n', info=True) }}
        {% set drop_queries = run_query(get_drop_commands_query).columns[1].values() %}


        {% for query in drop_queries %}
            {% if dry_run %}
                {{ log(query, info=True) }}
            {% else %}
                {{ log('Dropping object with command: ' ~ query, info=True) }}
                {% do run_query(query) %} 
            {% endif %}       
        {% endfor %}
    {% else %}

        {{ log('This is not execute mode', info=True)}}
        
    {% endif %}
    
    
{% endmacro %} 