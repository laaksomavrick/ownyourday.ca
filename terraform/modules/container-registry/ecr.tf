resource "aws_ecr_repository" "ownyourday-container-repo" {
  name                 = "ownyourday-container-repository"
  image_tag_mutability = "IMMUTABLE"

  tags = var.common_tags
}
