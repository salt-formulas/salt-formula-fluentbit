{%- from "fluentbit/map.jinja" import fluentbit with context %}
{%- if pillar.fluentbit.enabled %}

include:
- fluentbit.install
- fluentbit.config

{%- set config_files = [] %}
{%- for section in ['service', 'input', 'filter', 'output', 'parser', 'mixed'] %}
{%- for name in fluentbit.config.get(section, {}).keys() %}
{%- do config_files.append(section~"_"~name) %}
{%- endfor %}
{%- endfor %}

# Enable the service
td_agent_bit_service:
  service.running:
    - name: td-agent-bit
    - enable: True
    - require:
      - pkg: fluentbit_packages
      {%- for name in config_files %}
      - file: fluentbit_config_{{ name }}
      {%- endfor %}
    - watch:
      {%- for name in config_files %}
      - file: fluentbit_config_{{ name }}
      {%- endfor %}
    {%- if grains.get('noservices') %}
    - onlyif: /bin/false
    {%- endif %}

{%- else %}

# Disable the service
td_agent_bit_service:
  service.dead:
    - name: td-agent-bit
    - enable: False

{%- endif %}
