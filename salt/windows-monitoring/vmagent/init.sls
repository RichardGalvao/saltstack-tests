# Windows Monitoring - VMAgent State
#
# VictoriaMetrics Agent for scraping Windows Exporter metrics
# Only installed when windows_exporter_collectors is defined in pillar
# Uses pre-built binary (no Go compilation required)

{% set install_dir = salt['pillar.get']('monitoring:install_dir', 'C:\\Monitoring') %}
{% set version = salt['pillar.get']('monitoring:versions:vmagent', '1.102.3') %}
{% set winsw_version = salt['pillar.get']('monitoring:versions:winsw', '2.12.0') %}

# Create VMAgent directories
vmagent_directories:
  file.directory:
    - names:
      - {{ install_dir }}\VictoriaMetrics
      - {{ install_dir }}\VictoriaMetrics\Config
      - {{ install_dir }}\VictoriaMetrics\logs
      - {{ install_dir }}\Vmagent
    - makedirs: True

# Download pre-built VMAgent
download_vmagent:
  archive.extracted:
    - name: {{ install_dir }}\VictoriaMetrics
    - source: https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v{{ version }}/victoria-metrics-windows-amd64-v{{ version }}.zip
    - skip_verify: True
    - enforce_toplevel: False
    - if_missing: {{ install_dir }}\VictoriaMetrics\vmagent-prod.exe
    - require:
      - file: vmagent_directories

# Download WinSW service wrapper
download_winsw:
  file.managed:
    - name: {{ install_dir }}\Vmagent\vmagent-service.exe
    - source: https://github.com/winsw/winsw/releases/download/v{{ winsw_version }}/WinSW-x64.exe
    - skip_verify: True
    - require:
      - file: vmagent_directories

# Deploy VMAgent scrape configuration
vmagent_config:
  file.managed:
    - name: {{ install_dir }}\VictoriaMetrics\Config\vmagent.yml
    - source: salt://windows-monitoring/files/vmagent.yml.jinja
    - template: jinja
    - require:
      - file: vmagent_directories

# Deploy WinSW service definition
vmagent_service_xml:
  file.managed:
    - name: {{ install_dir }}\Vmagent\vmagent-service.xml
    - source: salt://windows-monitoring/files/vmagent.xml.jinja
    - template: jinja
    - require:
      - file: vmagent_directories
      - archive: download_vmagent

# Install VMAgent as Windows service
install_vmagent_service:
  cmd.run:
    - name: "{{ install_dir }}\\Vmagent\\vmagent-service.exe" install
    - unless: sc query vmagent
    - require:
      - file: download_winsw
      - file: vmagent_service_xml
      - file: vmagent_config

# Ensure VMAgent service is running
vmagent_service:
  service.running:
    - name: vmagent
    - enable: True
    - watch:
      - file: vmagent_config
    - require:
      - cmd: install_vmagent_service
