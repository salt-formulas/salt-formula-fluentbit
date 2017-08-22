{%- from "fluentbit/map.jinja" import fluentbit with context %}
{%- if fluentbit.enabled %}

# Repos should be configured by salt-formulas/salt-formula-linux
#

# Install packages
fluentbit_packages:
  package.install:
    - names: {{ fluentbit.pkgs | list }}

{% for name, config in fluentbit.confg %}
fluentbit_config_{{name}}:
    file.managed:
    - name: /{{ fluentbit.install_dir }}/{{ name }}
    - source:
      - salt://linux/files/fluentbit_{{ name }}
      - salt://linux/files/fluentbit.conf
    - template: jinja
    - defaults:
        script: {{ conf|yaml }}
    - require_in:
      - package: fluentbit_config
    - watch_in:
      - package: fluentbit_config
{%- endfor %}

td-agent-bit_service:
  service.running:
    - name: td-agent-bit
    - require: fluentbit_packages

{%- endif %}
