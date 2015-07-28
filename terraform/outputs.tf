output "address" {
  value = "${aws_instance.chef.public_dns}"
}
