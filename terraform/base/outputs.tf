output "default_subnet_id" {
  value = "${aws_subnet.default.id}"
}

output "default_elb_security_group_id" {
 value = "${aws_security_group.elb.id}"
}

output "default_security_group_id" {
 value = "${aws_security_group.default.id}"
}

output "external_connections_security_group_id" {
 value = "${aws_security_group.external_connections.id}"
}

output "default_vpc_id" {
  value = "${aws_vpc.default.id}"
}

output "cluster_security_group_id" {
 value = "${aws_security_group.cluster.id}"
}

