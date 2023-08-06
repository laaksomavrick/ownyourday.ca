resource "aws_ecs_cluster" "app_cluster" {
  name               = "${var.app_name}-cluster"
  capacity_providers = [aws_ecs_capacity_provider.app_capacity_provider.name]
  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.app_capacity_provider.name
    weight            = 1
    base              = 0
  }
}

resource "aws_ecs_capacity_provider" "app_capacity_provider" {
  name = "${var.app_name}-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.asg.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 90
    }
  }
}


resource "aws_ecs_service" "svc" {
  name            = "${var.app_name}-svc"
  cluster         = aws_ecs_cluster.app_cluster.arn
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 1
  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.app_capacity_provider.name
    weight            = 100
  }

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
}

resource "aws_ecs_task_definition" "service" {
  family                   = "${var.app_name}-task-definition"
  requires_compatibilities = ["EC2"]
  container_definitions = jsonencode([
    {
      healthCheck : {
        retries : 3,
        command : [
          "CMD-SHELL",
          "curl -f http://0.0.0.0:3000/ || exit 1"
        ],
        timeout : 5,
        interval : 30,
        startPeriod : null
      },
      essential : true,
      image : var.image_uri,
      logConfiguration : {
        logDriver : "awslogs",
        options : {
          "awslogs-group" : aws_cloudwatch_log_group.instance.name,
          "awslogs-region" : "ca-central-1",
          "awslogs-stream-prefix" : "ecs"
        }
      },
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        },
      ],
      name : var.app_name,
      cpu : 1000
      memory : 400, # Not 512 since host uses some memory
      // TODO: these are being passed in plaintext - refactor to use docker secrets or parameter store
      environment : [
        {
          name : "OWNYOURDAY_DATABASE_HOST",
          value : var.db_host
        },
        {
          name : "OWNYOURDAY_DATABASE_NAME",
          value : var.app_name
        },
        {
          name : "OWNYOURDAY_DATABASE_USERNAME",
          value : var.db_username
        },
        {
          name : "OWNYOURDAY_DATABASE_PASSWORD"
          value : var.db_password
        }
      ]
    }
  ])
}


