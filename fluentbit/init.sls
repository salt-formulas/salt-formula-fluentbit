{%- from "fluentbit/map.jinja" import fluentbit with context %}

{%- if pillar.fluentbit is defined %}

include:
{%- if pillar.fluentbit.enabled %}
- fluentbit.install
- fluentbit.config
{%- endif %}
- fluentbit.service

{%- endif %}
