# Example customer-specific pillar
# Copy this file and customize for each customer

monitoring:
  customer: example_customer

  # Customer-specific VictoriaMetrics credentials
  vmetrics:
    user: example_vmetricsuser
    password: example_encrypted_password

    # Customer can override clusters if needed
    # clusters:
    #   - host: customer-specific-cluster.example.com
    #     port: 30480
    #     user: customer_user
    #     password: customer_password

  # Customer-specific thresholds
  thresholds:
    cpu: 85
    mem: 85
    disk: 80

  # Customer-specific deploy version (git commit for alert suppression)
  # deploy_version: 'abc1234'
