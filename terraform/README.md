# terraform

Directory containing infrastructure as code declarations using Terraform

## How do I deploy changes?

- `cd` to the relevant `environments` subdirectory (`production` or `common`)
- `terraform init` (if required)
- `terraform plan`
- `terraform apply`

To validate changes prior to commit:

- `terraform fmt -recursive`
- `terraform validate`

## The plan (replace me prior to merging with a diagram e.g. mermaidjs)

### Application stack
- Routing: R53
- Load balancer: ELB (won't do depending on cost)
- App server: EC2 (maybe) - investigate Elastic Beanstalk cost versus ECS cost
- Database: RDS (db.t4g.micro)
- Asset delivery: Cloudfront and S3 (won't do immediately)

### Operation stack
- Logging:
- Monitoring:
- Alerting: 

Investigate New Relic versus AWS offerings for the above. TBD.

### Execution strategy

- Get load balancer running (need to refactor subnets a bit)
- Revisit security (sg, nacl)
- Setup SSL + move over domain (ownyourday.ca)
- Logging, monitoring, alerting setup
  - Can I check logs for errors when they occur?
  - Can I check metrics for performance stats?
    - Request latency
    - CPU utilization
    - Memory utilization
    - 2xx rate
    - non-2xx rate
  - Do I get notified when an error happens?
