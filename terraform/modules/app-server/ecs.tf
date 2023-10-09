resource "aws_ecs_cluster" "app_cluster" {
  name               = "${var.app_name}-cluster"
#  capacity_providers = [aws_ecs_capacity_provider.app_capacity_provider.name]
#  default_capacity_provider_strategy {
#    capacity_provider = aws_ecs_capacity_provider.app_capacity_provider.name
#    weight            = 1
#    base              = 0
#  }
}
#
#resource "aws_ecs_capacity_provider" "app_capacity_provider" {
#  name = "${var.app_name}-capacity-provider"
#
#  auto_scaling_group_provider {
#    auto_scaling_group_arn         = aws_autoscaling_group.asg.arn
#    managed_termination_protection = "DISABLED"
#
#    managed_scaling {
#      status          = "ENABLED"
#      target_capacity = 100
#    }
#  }
#}

resource "aws_ecs_service" "svc" {
  name            = "${var.app_name}-svc"
  cluster         = aws_ecs_cluster.app_cluster.arn
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 1
  launch_type = "FARGATE"

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

#  capacity_provider_strategy {
#    capacity_provider = aws_ecs_capacity_provider.app_capacity_provider.name
#    weight            = 100
#  }
  network_configuration {
    subnets = var.app_subnet_ids
    security_groups = var.ecs_security_group_ids
    assign_public_ip = true
  }

  service_registries {
    registry_arn   = var.cloudmap_service_arn
    port = var.container_port
  }

}

resource "aws_ecs_task_definition" "service" {
  family                   = "${var.app_name}-task-definition"
  requires_compatibilities = ["FARGATE"]
  task_role_arn = aws_iam_role.instance.arn
  execution_role_arn = aws_iam_role.instance.arn
  cpu = 256
  memory = 512
  network_mode = "awsvpc"
  container_definitions = jsonencode([
    {
      healthCheck : {
        retries : 5,
        command : [
          "CMD-SHELL",
          "curl -f http://0.0.0.0:${var.container_port}/ || exit 1"
        ],
        timeout : 5,
        interval : 60,
        startPeriod : null
      },
      essential : true,
      image : "${var.app_image_repo}:${var.app_image_version}",
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
          containerPort = var.container_port
          hostPort = var.container_port
        }
      ],
      name : var.app_name,
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
        },
        {
          name: "PORT",
          value: tostring(var.container_port)
        },
        {
          name : "RAILS_SERVE_STATIC_FILES" // TODO: serve these with CDN at some point
          value : "true"
        },
        {
          name : "APPLICATION_VERSION",
          value : var.app_image_version
        }
      ]
    }
  ])
}


