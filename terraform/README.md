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

#### Step 1:
- Dockerize the app + container registry
  - This goes into "common" via the modules
  - Make note that user will have to invoke CI to upload to registry for first-time run
  - Dockerize the app
  - Add CI step to upload to ECR on merge
  - PR time, rename branch to iac-container-registry

#### Step 2:
- VPC, public subnet, EC2
  - All this goes into "production" via the modules
- App server
  - Use EC2
    - Install docker with userdata or with an image that contains Docker by default
    - Docker environment platform
    - EC2: t4g.nano
    - ECR: hold 2 images per month, last and current
