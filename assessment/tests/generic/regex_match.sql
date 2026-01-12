{% test regex_match(model, column_name, pattern) %}

select *
from {{ model }}
where {{ column_name }} is not null
  and {{ column_name }} !~ '{{ pattern }}'

{% endtest %}

