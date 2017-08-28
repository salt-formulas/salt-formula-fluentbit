{% from 'fluentbit/_config.sls' import render_fluentbit_config with context %}

include:
- fluentbit.config.service
- fluentbit.config.filter
- fluentbit.config.input
- fluentbit.config.output
- fluentbit.config.parser
- fluentbit.config.mixed
