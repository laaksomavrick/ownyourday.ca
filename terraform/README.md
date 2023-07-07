# terraform

Directory containing infrastructure as code declarations using Terraform

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

#### Step 1:
- App server, database
