base:
  # Existing monitoring targets (Blackbox + VMAgent)
  'windows-agent*':
    - monitoring
  'thinkpad*':
    - monitoring

  # Windows Monitoring (Telegraf + optional Windows Exporter)
  # Target by OS grain - all Windows machines
  'G:os:Windows':
    - match: grain
    - windows-monitoring

  # Or target by explicit patterns
  # 'win-server-*':
  #   - windows-monitoring

  # Target by customer grain
  # 'customer:granado':
  #   - match: grain
  #   - windows-monitoring

  # Target by role grain (e.g., IIS servers)
  # 'roles:iis':
  #   - match: grain
  #   - windows-monitoring
