//# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster
//resource "aws_ecs_cluster" "app_cluster" {
//}
//
//# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service
//resource "aws_ecs_service" "app_service" {
//
//}
//
//# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_capacity_provider
//resource "aws_ecs_capacity_provider" "app_capacity_provider" {
//  name = "${var.app_name}_capacity_provider"
//
//  auto_scaling_group_provider {
//    auto_scaling_group_arn         = aws_autoscaling_group.app_asg.arn
//    managed_termination_protection = "ENABLED"
//
//   managed_scaling {
//      status                    = "ENABLED"
//      target_capacity           = 100
//    }
//  }
//}
//
//# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition
//resource "aws_ecs_task_definition" "service" {
//
//}
//
//resource "aws_iam_role" "instance" {
//  name = "${var.app_name}-instance-role"
//
//  assume_role_policy = <<EOF
//{
//  "Version": "2012-10-17",
//  "Statement": [
//    {
//      "Action": "sts:AssumeRole",
//      "Principal": {
//        "Service": "ec2.amazonaws.com"
//      },
//      "Effect": "Allow",
//      "Sid": ""
//    }
//  ]
//}
//EOF
//}
//
//resource "aws_iam_role_policy_attachment" "ecs_policy" {
//  role       = "${aws_iam_role.instance.name}"
//  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
//}
