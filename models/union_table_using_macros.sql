{% set event_relations = dbt_utils.get_relations_by_prefix(database='dbt-test-356909', schema='dbt_brant', prefix='stg_') %}
{{ dbt_utils.union_relations(relations = event_relations) }}