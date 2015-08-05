output "address" {
  value = "${aws_instance.chef.public_dns}"
}

output "address" {
  value = "${aws_instance.marathon.public_ip}"
}
