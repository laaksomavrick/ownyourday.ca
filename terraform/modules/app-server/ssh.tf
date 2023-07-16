resource "aws_key_pair" "deployer" {
  key_name   = "${var.app_name}-ssh-key"
  public_key = file(var.public_key_file_path) # TODO var
}
