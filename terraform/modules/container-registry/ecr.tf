resource "aws_ecr_repository" "ownyourday_container_repo" {
  name                 = "ownyourday"
  image_tag_mutability = "IMMUTABLE"

}
