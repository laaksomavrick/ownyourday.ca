resource "aws_ecr_repository" "ownyourday_container_repo" {
  name                 = "ownyourday"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_lifecycle_policy" "expire_all_except_last_policy" {
  repository = aws_ecr_repository.ownyourday_container_repo.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep only 6 images",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 6
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
