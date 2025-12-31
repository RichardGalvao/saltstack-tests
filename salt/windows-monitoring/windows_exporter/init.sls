# Windows Monitoring - Windows Exporter State
#
# Prometheus exporter for Windows metrics
# Only installed when windows_exporter_collectors is defined in pillar

{% set install_dir = salt['pillar.get']('monitoring:install_dir', 'C:\\Monitoring') %}
{% set version = salt['pillar.get']('monitoring:versions:windows_exporter', '0.29.0') %}
{% set collectors = salt['pillar.get']('monitoring:windows_exporter_collectors', []) | join(',') %}

# Create Windows Exporter directories
windows_exporter_directories:
  file.directory:
    - names:
      - {{ install_dir }}\WindowsExporter
      - {{ install_dir }}\WindowsExporter\logs
    - makedirs: True

# Download Windows Exporter MSI
download_windows_exporter:
  file.managed:
    - name: {{ install_dir }}\WindowsExporter\windows_exporter-{{ version }}-amd64.msi
    - source: https://github.com/prometheus-community/windows_exporter/releases/download/v{{ version }}/windows_exporter-{{ version }}-amd64.msi
    - skip_verify: True
    - require:
      - file: windows_exporter_directories

# Install Windows Exporter via MSI
install_windows_exporter:
  cmd.run:
    - name: >
        msiexec /i "{{ install_dir }}\WindowsExporter\windows_exporter-{{ version }}-amd64.msi"
        ENABLED_COLLECTORS="{{ collectors }}"
        LISTEN_PORT=9182
        EXTRA_FLAGS="--log.file={{ install_dir }}\WindowsExporter\logs\windows_exporter.log --log.level=info"
        /quiet /norestart
    - unless: sc query windows_exporter
    - require:
      - file: download_windows_exporter

# Ensure Windows Exporter service is running
windows_exporter_service:
  service.running:
    - name: windows_exporter
    - enable: True
    - require:
      - cmd: install_windows_exporter
