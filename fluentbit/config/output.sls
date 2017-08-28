{% from 'fluentbit/_config.sls' import render_fluentbit_config with context %}

{{ render_fluentbit_config('output') }}
