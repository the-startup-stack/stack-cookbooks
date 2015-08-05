provider "aws" {
    region = "${var.aws_region}"
}

resource "aws_security_group" "default" {
    name = "external_connection"
    description = "Default Security Group"

    # SSH into machines
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.your_ip_address}/32"]
    }

    # Mesos web UI
    ingress {
        from_port = 5050
        to_port = 5050
        protocol = "tcp"
        cidr_blocks = ["${var.your_ip_address}/32"]
    }

    # HTTP access from anywhere
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "cluster" {
    name = "cluter"
    description = "Cluster Security Group"

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        security_groups = ["${aws_security_group.default.id}"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "chef" {
  instance_type = "m3.large"
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.default.name}"]

  tags {
      Name = "chef"
  }

  user_data = "${file(\"chef-userdata.yml\")}"
}

resource "aws_instance" "marathon" {
  instance_type = "m4.large"
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.cluster.name}", "${aws_security_group.default.name}"]

  tags {
      Name = "mesos"
  }

  user_data = "${file(\"mesos-userdata.yml\")}"
}
