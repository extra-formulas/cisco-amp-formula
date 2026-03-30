{%- set default_sources = {'module' : 'cisco_amp', 'pillar' : True, 'grains' : ['os_family']} %}
{%- from "./defaults/load_config.jinja" import config as cisco_amp with context %}

{% if cisco_amp.use is defined %}

{% if cisco_amp.use | to_bool %}

cisco_amp_connector_installation:
  pkg.installed:
    - name: {{ cisco_amp.package_name }}
{% if cisco_amp.package_file is defined %}
    - sources:
      - {{ cisco_amp.package_name }}: {{ cisco_amp.package_file }}
{% endif %}

cisco_amp_service_running:  
  service.running:
    - name: {{ cisco_amp.service_name }}
    - enable: True
    - require:
      - cisco_amp_connector_installation
    - watch:
      - cisco_amp_connector_installation

{% else %}

cisco_amp_service_stopped:  
  service.dead:
    - name: {{ cisco_amp.service_name }}
    - enable: False

cisco_amp_connector_removal:
  pkg.removed:
    - name: {{ cisco_amp.package_name }}
    - require:
      - cisco_amp_service_stopped

{% endif %}

{% endif %}