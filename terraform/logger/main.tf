module "base" {
  source = "../base"
  your_ip_address = "${var.your_ip_address}"
}

resource "aws_security_group" "logger" {
    name        = "logger"
    description = "Logger Security Group"
    vpc_id      = "${module.base.default_vpc_id}"

    ingress {
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        security_groups = ["${module.base.cluster_security_group_id}"]
    }

    ingress {
        from_port       = 0
        to_port         = 65535
        protocol        = "udp"
        security_groups = ["${module.base.cluster_security_group_id}"]
    }
}

resource "aws_instance" "logger" {
  instance_type   = "m4.large"
  ami             = "${lookup(var.aws_amis, var.aws_region)}"
  key_name        = "${var.key_name}"
  vpc_security_group_ids = ["${module.base.cluster_security_group_id}", "${aws_security_group.logger.id}"]

  tags {
      Name = "logger"
  }

  user_data = "${file(\"logger-userdata.yml\")}"
}
