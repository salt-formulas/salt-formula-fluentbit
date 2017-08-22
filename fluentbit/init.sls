{%- if pillar.fluentbit is defined %}
include:
{%- if pillar.fluentbit.fluentbit is defined %}
- fluentbit.fluentbit
{%- endif %}
{%- endif %}
