{# dbt default would prefix target.schema (e.g. dbt_dev_staging).
   We override so +schema: staging / mart in dbt_project.yml maps
   directly to the Terraform datasets, regardless of the profile target. #}
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- if custom_schema_name is none -%}
        {{ target.schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
