module "web_base" {
  source = "../web_base"
  your_ip_address = "${var.your_ip_address}"
}

resource "aws_security_group" "chef" {
    name        = "chef"
    description = "Chef Security Group"
    vpc_id      = "${module.web_base.default_vpc_id}"

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "chef" {
  instance_type          = "m3.large"
  ami                    = "${lookup(var.aws_amis, var.aws_region)}"
  key_name               = "${var.key_name}"
  subnet_id              = "${module.web_base.default_subnet_id}"
  vpc_security_group_ids = ["${module.web_base.default_security_group_id}", "${module.web_base.external_connections_security_group_id}"]

  tags {
      Name = "chef"
  }

  user_data = "${file(\"chef-userdata.yml\")}"
}
