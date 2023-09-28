output "db_host" {
  value = aws_db_instance.database.address
}

output "db_arn" {
  value = aws_db_instance.database.arn
}

output "db_identifier" {
  value = aws_db_instance.database.identifier
}
