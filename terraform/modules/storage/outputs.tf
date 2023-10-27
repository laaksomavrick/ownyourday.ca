output "bucket_arn" {
  value = aws_s3_bucket.app_bucket.arn
}

output "bucket_name" {
  value = "${var.app_name}-app-bucket"
}
