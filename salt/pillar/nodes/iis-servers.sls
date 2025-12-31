# IIS Server specific pillar
# Applied to nodes with 'roles:iis' grain

monitoring:
  # Enable Windows Exporter with IIS collector
  windows_exporter_collectors:
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
    - iis  # IIS-specific collector

  # Enable Telegraf service monitoring
  telegraf_collectors:
    - service

  # IIS services to monitor
  monitor_services:
    - W3SVC
    - WAS
