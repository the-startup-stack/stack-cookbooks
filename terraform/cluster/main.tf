module "base" {
  source = "../base"
  your_ip_address = "${var.your_ip_address}"
}

resource "aws_security_group" "marathon" {
    name        = "chef"
    description = "Chef Security Group"
    vpc_id      = "${module.base.default_vpc_id}"

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "marathon" {
  instance_type   = "m4.large"
  ami             = "${lookup(var.aws_amis, var.aws_region)}"
  key_name        = "${var.key_name}"
  vpc_security_group_ids = ["${module.base.cluster_security_group_id}", "${module.base.default_security_group_id}"]
  subnet_id  = "${module.base.default_subnet_id}"

  tags {
      Name = "mesos"
  }

  user_data = "${file(\"mesos-userdata.yml\")}"
}
