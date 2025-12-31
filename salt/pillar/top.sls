base:
  # Tier 1: Global defaults (all minions)
  '*':
    - monitoring.defaults

  # Tier 2: Customer-specific (loaded after defaults)
  # Example: 'customer:granado':
  #   - match: grain
  #   - customers.granado

  # Tier 3: Node-specific (loaded last, highest priority)
  # Example: 'win-db-server-01':
  #   - nodes.win-db-server-01

  # Role-based overrides
  # Example: 'roles:iis':
  #   - match: grain
  #   - nodes.iis-servers
