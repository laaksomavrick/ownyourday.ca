resource "aws_ecr_repository" "ownyourday_container_repo" {
  name                 = "ownyourday-container-repository"
  image_tag_mutability = "IMMUTABLE"

}
