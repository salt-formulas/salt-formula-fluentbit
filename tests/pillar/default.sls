linux:
  system:
    enabled: true
fluentbit:
  enabled: true
  repo:
    enabled: true
  service: &service
    flush: 10
    daemon: 'off'
    log_level: info
    parsers_file:
      - parser_custom.conf
      - parser_custom.conf
      - parser_my.conf
  config:
    service:
      defaults.conf:
        service: *service
      td-agent-bit.conf:
          - '@INCLUDE defaults.conf'
          - '@INCLUDE input_metrics.conf'
          - '@INCLUDE mixed_proc.conf'
          - '@INCLUDE output_metrics.conf'
          - '@INCLUDE output_elastic.conf'
    parser:
      custom.conf: |
        @INCLUDE parsers.conf
        @INCLUDE parser_docker2.conf
      docker2.conf:
        docker-daemon:
          format: regex
          regex: 'time="(?<time>[^ ]*)" level=(?<level>[^ ]*) msg="(?<msg>[^ ].*)"'
          time_key: time
          time_format: '%Y-%m-%dT%H:%M:%S.%L'
    input:
      flexible_example.conf: |
        # as fallback, whatever syntax is supported input
        [CUSTOM]
          xyz = aaa
      metrics.conf:
        cpu:
          name: cpu
          tag: my_cpu
        local_disk:
          name: disk
          tag: storage
      systemd.conf:
        systemd:
          tag: 'host.*'
          systemd_filter:
            - _SYSTEM_UNIT=*.service
            - _SYSTEM_UNIT=*.network
            - _SYSTEM_UNIT=*.boot
    output:
      elastic.conf:
        es:
          match: 'my*'
          name: es
      metrics.conf:
        stdout:
          match: 'my*'
          # name: stdout
    mixed:
      proc.conf:
        proc_input:
          section: input
          name: proc
          tag: my_proc
        proc_to_stdout:
          section: output
          name: stdout
          tag: my_proc



