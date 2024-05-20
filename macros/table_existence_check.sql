
{%- macro table_existence_check(table_name=model.name, schema=this.schema , database=target.database) %}

    {{ log('Checking if table ' ~ table_name ~ ' exists', info=True) }}
    {{ log('Database: ' ~ database, info=True) }}
    {{ log('Schema: ' ~ schema, info=True) }}
    {{ log('Identifier: ' ~ table_name, info=True) }}
{% endmacro %}