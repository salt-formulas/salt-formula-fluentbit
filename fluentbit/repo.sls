{%- from "fluentbit/map.jinja" import fluentbit with context %}

{%- if fluentbit.repo.enabled %}

include:
- linux.system.repo

{%- endif %}
