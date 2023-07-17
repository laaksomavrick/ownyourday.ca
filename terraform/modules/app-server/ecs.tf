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
      command : [
        "/bin/sh -c \"echo '<html> <head> <title>Amazon ECS Sample App</title> <style>body {margin-top: 40px; background-color: #333;} </style> </head><body> <div style=color:white;text-align:center> <h1>Amazon ECS Sample App</h1> <h2>Congratulations!</h2> <p>Your application is now running on a container in Amazon ECS.</p> </div></body></html>' >  /usr/local/apache2/htdocs/index.html && httpd-foreground\""
      ],
      entryPoint : [
        "sh",
        "-c"
      ],
      //      healthCheck: {
      //        retries: 3,
      //        command: [
      //          "CMD-SHELL",
      //          "curl -f http://localhost:8080/ || exit 1"
      //        ],
      //        timeout: 5,
      //        interval: 30,
      //        startPeriod: null
      //      },
      essential : true,
      image : "httpd:2.4",
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
          containerPort = 80
          hostPort      = 80
        },
        {
          containerPort = 443
          hostPort      = 443
        }
      ],
      name : "hello-world",
      cpu : 1024
      memory : 512,
    }
  ])
}


