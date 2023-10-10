resource "aws_iam_openid_connect_provider" "github_provider" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"]
}

resource "aws_iam_role" "pipeline_role" {
  name = "OwnyourdayPipelineRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : aws_iam_openid_connect_provider.github_provider.arn
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringLike" : {
            "token.actions.githubusercontent.com:sub" : "repo:${var.github_repo_path}:*"
          }
        }
      }
    ]
  })

}

data "aws_iam_policy_document" "pipeline_role_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:*"
    ]
    resources = [
      var.container_registry_arn,
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:*",
      "ec2:*",
      "ecs:*",
      "logs:*",
      "iam:*",
      "autoscaling:*",
      "rds:*",
      "elasticloadbalancing:*",
      "acm:*",
      "route53:*",
      "sns:*",
      "cloudwatch:*",
      "cloudfront:*"

    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "pipeline_role_policy" {
  name   = "OwnyourdayPipelineRolePolicy"
  policy = data.aws_iam_policy_document.pipeline_role_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "pipeline_role_policy_attachment" {
  role       = aws_iam_role.pipeline_role.name
  policy_arn = aws_iam_policy.pipeline_role_policy.arn
}
