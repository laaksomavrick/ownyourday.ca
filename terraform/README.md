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
  - ECR repository declaration in `common`
    - Make note that user will have to invoke CI to upload to registry for first-time run
  - Dockerize the app
  - Create ContinuousDeployment role for Ownyourday (only upload to ECR for the moment) in `common`
  - Add CI step to upload to ECR on merge
  - PR time, rename branch to iac-container-registry

#### Step 2:
- VPC, subnet, security group
  - All this goes into "production" via the modules
- App server
  - Use EC2 backed ECS
    - Maybe use ECS instead with EC2 launch type with a t4g.nano; handles a lot of the leg work?
    - ECR: hold 2 images per month, last and current

- Get app server running ownyourday docker image
=> https://docs.docker.com/build/ci/github-actions/secrets/
- need to pass RAILS_MASTER_KEY via env for Docker


- Update CI to add var for newly uploaded image and apply tf updates (will need to modify PipelineRole ?)

- Get db running
- Get load balancer running
- Revisit security (sg, nacl)
- Setup SSL + move over domain (ownyourday.ca)

- Logging, monitoring, alerting setup
