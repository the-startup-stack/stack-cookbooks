output "address" {
  value = "${aws_instance.chef.public_dns}"
}

output "address" {
  value = "${aws_instance.logger.public_up}"
}

output "address" {
  value = "${aws_instance.sensu.public_up}"
}

output "address" {
  value = "${aws_instance.marathon.public_ip}"
}
