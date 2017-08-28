
==================================
fluentbit formula
==================================

Fluent Bit is an open source and multi-platform Log Forwarder which allows you to collect data/logs from different sources, unify and send them to multiple destinations. It's fully compatible with Docker and Kubernetes environments.

**NOTE: WORK IN PROGRES**
NOTE: DESIGN OF THIS FORMULA IS NOT YET STABLE AND MAY CHANGE

Sample pillars
==============

Single fluentbit service

.. code-block:: yaml

  fluentbit:
    enabled: true
    service: &service
      flush: 10
      daemon: 'on'
      log_level: info
      parsers_file: parsers.conf
    service:
      defaults.conf:
        service: \*service
      td-agent-bit.conf:
          - '@INCLUDE defaults.conf'

Config files are rendered from these ``section`` sections:

.. code-block:: yaml

  fluentbit:
    config:
      input: {}
      output: {}
      parser: {}
      service: {}
      filter: {}

``fluentbit:conf`` section suport syntax can be yaml, plain text or list.
Yaml structured examples:

.. code-block:: yaml

  fluentbit:
    service:
      td-agent-bit.conf:
          service:
            flush: 10
          output:
            name: es
            match: '*'

.. code-block:: yaml

  fluentbit:
    input:
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
    parser:
      custom.conf: |
        @INCLUDE parsers.conf

Plaint text structured example:

.. code-block:: yaml

    td-agent-bit.conf: |
      [SERVICE]
        Daemon off

      @SET KEY=VAL

      [CUSTOM]
        xyz = aaa

      @INCLUDE filters_out.conf

List structured example is used for example for include statemetns in the main ``td-agent-bit.conf`` file:

.. code-block:: yaml

      td-agent-bit.conf:
          - '@INCLUDE metrics_in.conf'
          - '@INCLUDE elastic_out.conf'

If the filter key may be specified multiple times, define it as a list.

.. code-block:: yaml

    systemd.conf:
      systemd:
        tag: 'host.*'
        systemd_filter:
          - _SYSTEM_UNIT=*.service
          - _SYSTEM_UNIT=*.boot

You may use ``section`` in any ``fluentbit:*:*.conf`` section, but for convenience and clean pillars there is special one ``mixed`` for
config files where you will mix individual sections and setup:

.. code-block:: yaml
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


Sample shared metadata/service pillars
======================================
This functionality requires `<https://github.com/salt-formulas/reclass>`_
and probably you want to reuse all features of salt-formulas and shared
system model `<https://github.com/Mirantis/reclass-system-salt-model/blob/master/fluentbit>`_.

There are most common pre-defined service classes for common input:

.. code-block:: yaml

classes:
 - system.fluentbit.single
 # the above should load some of these available:
 - service.fluentbit.support
 - service.fluentbit.config.input.metrics
 - service.fluentbit.config.input.system
 - service.fluentbit.config.output.stdout

More information
================

* http://fluentbit.io/

Documentation and Bugs
======================

To learn how to install and update salt-formulas, consult the documentation
available online at:

    http://salt-formulas.readthedocs.io/

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate issue tracker. Use GitHub issue tracker for specific salt
formula:

    https://github.com/salt-formulas/salt-formula-fluentbit/issues

For feature requests, bug reports or blueprints affecting entire ecosystem,
use Launchpad salt-formulas project:

    https://launchpad.net/salt-formulas

Developers wishing to work on the salt-formulas projects should always base
their work on master branch and submit pull request against specific formula.

You should also subscribe to mailing list (salt-formulas@freelists.org):

    https://www.freelists.org/list/salt-formulas

Any questions or feedback is always welcome so feel free to join our IRC
channel:

    #salt-formulas @ irc.freenode.net

Read more
=========

* links
