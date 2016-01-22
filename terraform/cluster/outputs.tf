output "address" {
  value = "${aws_instance.marathon.public_ip}"
}
