output "reverse_proxy_public_ip" {
  value = aws_instance.reverse_proxy.public_ip
}
