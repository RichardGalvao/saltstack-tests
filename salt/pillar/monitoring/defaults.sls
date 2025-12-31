# Global monitoring defaults
# These values are inherited by all minions and can be overridden
# in customer-specific or node-specific pillars

monitoring:
  # Installation directory
  install_dir: 'C:\Monitoring'

  # VictoriaMetrics configuration
  vmetrics:
    # Global credentials (fallback if not specified per-cluster)
    user: vmetricsuser
    password: changeme
    prefix_url: '/insert/0/prometheus/api/v1/write'

    # Cluster list with collapse merge support
    # Per-cluster user/password overrides global values
    clusters:
      - host: vmcluster-az-a.systemframe.com.br
        port: 30480
        # user/password inherited from global

      - host: vmcluster-az-b.systemframe.com.br
        port: 30480
        # user/password inherited from global

  # Component versions
  versions:
    windows_exporter: '0.29.0'
    vmagent: '1.102.3'
    telegraf: '1.28.0'
    nssm: '2.24'
    winsw: '2.12.0'

  # SHA256 checksums for integrity verification
  checksums:
    telegraf_exe: '4f22bf3dc3e00967d464df04b8926d159e7ad814af5ac80d60089b929db82ede'
    telegraf_zip: '3586051f47b05d1b2869cac8e77d7418537ce5b5464cf3891cdb0d1b62996485'
    vmagent_exe: '1bcfef0a8a546d566657d74baab7e9edd4f98b22832c40d5aae29d212d29dc1b'

  # Default Windows Exporter collectors (only used when windows_exporter_collectors is set)
  default_windows_exporter_collectors:
    - os
    - cpu
    - logical_disk
    - memory
    - net
    - physical_disk
    - service
    - system
    - process
    - cs
    - tcp
    # Disabled due to performance issues:
    # - netframework
    # - thermalzone
    # - update
    # - time
    # - remote_fx

  # Scrape settings
  scrape_interval: '15s'
  scrape_timeout: '15s'

  # Agent settings
  agent:
    interval: '30s'
    batch_size: 1000
    buffer_limit: 10000

  # Default thresholds for alerting
  thresholds:
    cpu: 90
    mem: 90
    disk: 90

  # Telegraf collectors (optional features)
  # telegraf_collectors:
  #   - process
  #   - service

  # Services to monitor (when 'service' is in telegraf_collectors)
  # monitor_services:
  #   - W3SVC
  #   - MSSQLSERVER
