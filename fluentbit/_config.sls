{%- from "fluentbit/map.jinja" import fluentbit with context %}

# Render configs
{%- macro render_fluentbit_config(section) %}
{%- for name,conf in fluentbit.config.get(section, {}).iteritems() %}
{%- if conf is mapping %}
{%- set template = conf.get('template', name) %}
{%- else %}
# to allow support for non structured config input
# process as raw text data
{%- set template = 'blank.conf' %}
{%- set conf = conf|sequence|sort|join('\n') %}
{%- endif %}
fluentbit_config_{{ section }}_{{name}}:
    file.managed:
    - name: {{ fluentbit.config_dir }}/{% if name not in ['fluentbit.conf', 'td-agent-bit.conf', 'parsers.conf'] %}{{ section }}_{% endif %}{{ name }}
    - source:
      - salt://fluentbit/files/{{ template }}
      - salt://fluentbit/files/default.conf
    - template: jinja
    - makedirs: True
    - defaults:
        config: {{ conf|yaml }}
        section: {{ section }}
    #- require_in:
       #- pkg: fluentbit_packages
    #- require_in:
      #- service: td_agent_bit_service
    #- watch_in:
      #- service: td_agent_bit_service
{%- endfor %}
{%- endmacro %}
