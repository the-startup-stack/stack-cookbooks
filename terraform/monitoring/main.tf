resource "aws_instance" "sensu" {
  instance_type   = "m4.large"
  ami             = "${lookup(var.aws_amis, var.aws_region)}"
  key_name        = "${var.key_name}"
  security_groups = ["${aws_security_group.cluster.name}", "${aws_security_group.external_connections.name}", "${aws_security_group.sensu.name}"]

  tags {
      Name = "sensu"
  }

  user_data = "${file(\"sensu-userdata.yml\")}"
}
