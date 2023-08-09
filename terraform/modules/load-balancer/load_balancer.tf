resource "aws_lb" "app_load_balancer" {
  name               = "${var.app_name}-app-load-balancer"
  load_balancer_type = "application"
  security_groups    = var.lb_security_group_ids
  subnets            = var.lb_subnet_ids

  enable_deletion_protection = true

  # TODO: alb logging
  #  access_logs {
  #    bucket  = aws_s3_bucket.lb_logs.id
  #    prefix  = "test-lb"
  #    enabled = true
  #  }
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"
  #  ssl_policy        = "ELBSecurityPolicy-2016-08"
  #  certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_lb_target_group.arn
  }
}

resource "aws_lb_target_group" "app_lb_target_group" {
  name     = "${var.app_name}-lb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.app_vpc_id

  health_check {
    protocol = "HTTP"
    path     = "/users/sign_in" # TODO health check endpoint
    timeout  = 5
    interval = 15
  }
}
