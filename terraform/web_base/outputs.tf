output "default_subnet_id" {
  value = "${aws_subnet.default.id}"
}

output "default_elb_security_group_id" {
 value = "${aws_security_group.elb.id}"
}

output "external_connections_security_group_id" {
 value = "${aws_security_group.external_connections.id}"
}

output "default_security_group_id" {
 value = "${aws_security_group.default.id}"
}
