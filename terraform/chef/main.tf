module "base" {
  source = "../base"
  your_ip_address = "${var.your_ip_address}"
}

resource "aws_security_group" "chef" {
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

resource "template_file" "chef_bootstrap" {
  template = "${file("chef_bootstrap.tpl")}"

  vars {
    chef_username = "${var.chef_username}"
    chef_user = "${var.chef_user}"
    chef_password = "${var.chef_password}"
    chef_user_email = "${var.chef_user_email}"
    chef_organization_id = "${var.chef_organization_id}"
    chef_organization_name = "${var.chef_organization_name}"
  }
}

resource "template_file" "chef_userdata" {
  template = "${file("chef_userdata.tpl")}"

  vars {
    domain_name = "${var.domain_name}"
  }
}

resource "aws_instance" "chef" {
  instance_type          = "m3.large"
  ami                    = "${lookup(var.aws_amis, var.aws_region)}"
  key_name               = "${var.key_name}"
  subnet_id              = "${module.base.default_subnet_id}"
  vpc_security_group_ids = ["${module.base.default_security_group_id}", "${module.base.external_connections_security_group_id}"]

  tags {
      Name = "chef"
  }

  provisioner "file" {
    source = "${var.certificate_file}"
    destination = "/tmp/server_certificate.pem"
    connection {
      user = "ubuntu"
    }
  }

  provisioner "file" {
    source = "${var.certificate_key}"
    destination = "/tmp/server_certificate.key"
    connection {
      user = "ubuntu"
    }
  }

  provisioner "remote-exec" {
    connection {
      user = "ubuntu"
    }
    inline = [
      "echo '${file("chef_certificate_configuration.tpl")}' > /tmp/chef-server.rb",
      "echo '${template_file.chef_bootstrap.rendered}' > /tmp/bootstrap-chef-server.sh",
      "chmod +x /tmp/bootstrap-chef-server.sh",
      "sudo sh /tmp/bootstrap-chef-server.sh"
    ]
  }

  user_data = "${template_file.chef_userdata.rendered}"
}

resource "aws_eip" "chef" {
    instance = "${aws_instance.chef.id}"
    vpc = true
}
