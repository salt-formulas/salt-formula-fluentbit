{%- from "fluentbit/map.jinja" import fluentbit with context %}

include:
- fluentbit.repo

# Install packages
fluentbit_packages:
  pkg.installed:
    - names: {{ fluentbit.pkgs |sequence }}

