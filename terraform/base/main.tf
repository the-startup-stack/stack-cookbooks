provider "aws" {
    region = "${var.aws_region}"
}

resource "aws_security_group" "external_connections" {
    name = "external_connection"
    description = "External Connections Security Group"

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
    name = "cluster"
    description = "Cluster Security Group"

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        self = true
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "chef" {
    name = "chef"
    description = "Chef Security Group"

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "logger" {
    name = "logger"
    description = "Logger Security Group"

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        security_groups = ["${aws_security_group.cluster.id}"]
    }

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "udp"
        security_groups = ["${aws_security_group.cluster.id}"]
    }
}

resource "aws_security_group" "stats" {
    name = "stats"
    description = "Stats Security Group"

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        security_groups = ["${aws_security_group.cluster.id}"]
    }

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "udp"
        security_groups = ["${aws_security_group.cluster.id}"]
    }
}

resource "aws_security_group" "sensu" {
    name = "sensu"
    description = "Sensu Security Group"

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        security_groups = ["${aws_security_group.cluster.id}"]
    }

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "udp"
        security_groups = ["${aws_security_group.cluster.id}"]
    }
}

resource "aws_instance" "chef" {
  instance_type = "m3.large"
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.external_connections.name}", "${aws_security_group.chef.name}"]

  tags {
      Name = "chef"
  }

  user_data = "${file(\"chef-userdata.yml\")}"
}

resource "aws_instance" "marathon" {
  instance_type = "m4.large"
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.cluster.name}", "${aws_security_group.external_connections.name}"]

  tags {
      Name = "mesos"
  }

  user_data = "${file(\"mesos-userdata.yml\")}"
}

resource "aws_instance" "sensu" {
  instance_type = "m4.large"
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.cluster.name}", "${aws_security_group.external_connections.name}", "${aws_security_group.sensu.name}"]

  tags {
      Name = "sensu"
  }

  user_data = "${file(\"sensu-userdata.yml\")}"
}

resource "aws_instance" "logger" {
  instance_type = "m4.large"
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.cluster.name}", "${aws_security_group.external_connections.name}", "${aws_security_group.logger.name}"]

  tags {
      Name = "logger"
  }

  user_data = "${file(\"logger-userdata.yml\")}"
}

resource "aws_instance" "stats" {
  instance_type = "m4.large"
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.cluster.name}", "${aws_security_group.external_connections.name}", "${aws_security_group.stats.name}"]

  tags {
      Name = "stats"
  }

  user_data = "${file(\"stats-userdata.yml\")}"
}

resource "aws_instance" "sensu" {
  instance_type = "m4.large"
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.cluster.name}", "${aws_security_group.external_connections.name}"]

  tags {
      Name = "sensu"
  }

  user_data = "${file(\"sensu-userdata.yml\")}"
}
