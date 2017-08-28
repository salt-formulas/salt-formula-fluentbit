{%- from 'fluentbit/map.jinja' import fluentbit with context %}
{%- from 'fluentbit/_config.sls' import render_fluentbit_config with context %}

{{ render_fluentbit_config('service') }}
