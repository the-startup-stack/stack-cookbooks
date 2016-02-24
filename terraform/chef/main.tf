resource "aws_vpc" "chef" {
  tags {
      Name = "chef-vpc"
  }
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "template_file" "chef_userdata" {
  template = "${file("chef_userdata.tpl")}"

  vars {
    domain_name = "${var.domain_name}"
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

resource "aws_instance" "chef" {
  instance_type          = "m3.large"
  ami                    = "${lookup(var.aws_amis, var.aws_region)}"
  key_name               = "${var.key_name}"
  subnet_id              = "${aws_subnet.chef.id}"
  vpc_security_group_ids = ["${aws_security_group.chef.id}", "${aws_security_group.external_connections.id}"]

  tags {
      Name = "chef"
  }

  provisioner "remote-exec" {
    connection {
      user = "ubuntu"
    }
    inline = [
      "echo '${template_file.chef_bootstrap.rendered}' > /tmp/bootstrap-chef-server.sh",
      "chmod +x /tmp/bootstrap-chef-server.sh",
      "sudo sh /tmp/bootstrap-chef-server.sh"
    ]
  }

  user_data = "${template_file.chef_userdata.rendered}"
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.chef.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.chef.id}"
}

resource "aws_internet_gateway" "chef" {
  tags {
      Name = "chef-gateway"
  }
  vpc_id = "${aws_vpc.chef.id}"
}

resource "aws_subnet" "chef" {
  tags {
      Name = "chef-subnet"
  }
  vpc_id                  = "${aws_vpc.chef.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "chef" {
  name        = "chef"
  description = "Used in the terraform"
  vpc_id      = "${aws_vpc.chef.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # HTTPS access from everywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "external_connections" {
  name        = "external_connection"
  description = "External Connections Security Group"
  vpc_id      = "${aws_vpc.chef.id}"

  # SSH into machines
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.your_ip_address}/32"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
