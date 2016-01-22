module "base" {
  source = "../base"
  your_ip_address = "${var.your_ip_address}"
}

resource "aws_instance" "marathon" {
  instance_type   = "m4.large"
  ami             = "${lookup(var.aws_amis, var.aws_region)}"
  key_name        = "${var.key_name}"
  vpc_security_group_ids = ["${module.base.cluster_security_group_id}", "${module.base.default_security_group_id}"]

  tags {
      Name = "mesos"
  }

  user_data = "${file(\"mesos-userdata.yml\")}"
}
