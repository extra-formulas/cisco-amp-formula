{%- set default_sources = {'module' : 'cisco_amp', 'defaults' : True, 'pillar' : True, 'grains' : []} %}
{% from "extra_formulas_common/load_config.jinja" import config as cisco_amp with context -%}

{% if cisco_amp.use is defined %}

{% if cisco_amp.use | to_bool %}

cisco-amp-connector-installed:
  pkg.installed:
    - name: {{ cisco_amp.package_name }}

cisco-amp-connector-running:
  service.running:
    - name: {{ cisco_amp.service_name }}
    - enable: True
    - require:
      - pkg: {{ cisco_amp.package_name }}
    - watch:
      - pkg: {{ cisco_amp.package_name }}

{% else %}

cisco-amp-connector-stopped:
  service.dead:
    - name: {{ cisco_amp.service_name }}
    - enable: False

cisco-amp-connector-removed:
  pkg.removed:
    - name: {{ cisco_amp.package_name }}
    - require:
      - service: {{ cisco_amp.service_name }}

{% endif %}

formula-cisco-amp-connector-is-disabled:
  test.show_notification:
    - text: |
        The cisco-amp-connector formula is disabled for this host
        You could enable it by setting the "use" flag in the pillar

{% endif %}
