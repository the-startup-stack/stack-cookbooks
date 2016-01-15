provider "aws" {
    region = "${var.aws_region}"
}

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_security_group" "cluster" {
  name        = "cluster"
  description = "Cluster Security Group"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "logger" {
    name        = "logger"
    description = "Logger Security Group"
    vpc_id      = "${aws_vpc.default.id}"

    ingress {
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        security_groups = ["${aws_security_group.cluster.id}"]
    }

    ingress {
        from_port       = 0
        to_port         = 65535
        protocol        = "udp"
        security_groups = ["${aws_security_group.cluster.id}"]
    }
}

resource "aws_security_group" "stats" {
    name        = "stats"
    description = "Stats Security Group"
    vpc_id      = "${aws_vpc.default.id}"

    ingress {
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        security_groups = ["${aws_security_group.cluster.id}"]
    }

    ingress {
        from_port       = 0
        to_port         = 65535
        protocol        = "udp"
        security_groups = ["${aws_security_group.cluster.id}"]
    }
}

resource "aws_security_group" "sensu" {
    name        = "sensu"
    description = "Sensu Security Group"
    vpc_id      = "${aws_vpc.default.id}"

    ingress {
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        security_groups = ["${aws_security_group.cluster.id}"]
    }

    ingress {
        from_port       = 0
        to_port         = 65535
        protocol        = "udp"
        security_groups = ["${aws_security_group.cluster.id}"]
    }
}

resource "aws_instance" "marathon" {
  instance_type   = "m4.large"
  ami             = "${lookup(var.aws_amis, var.aws_region)}"
  key_name        = "${var.key_name}"
  security_groups = ["${aws_security_group.cluster.name}", "${aws_security_group.external_connections.name}"]

  tags {
      Name = "mesos"
  }

  user_data = "${file(\"mesos-userdata.yml\")}"
}

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

resource "aws_instance" "logger" {
  instance_type   = "m4.large"
  ami             = "${lookup(var.aws_amis, var.aws_region)}"
  key_name        = "${var.key_name}"
  security_groups = ["${aws_security_group.cluster.name}", "${aws_security_group.external_connections.name}", "${aws_security_group.logger.name}"]

  tags {
      Name = "logger"
  }

  user_data = "${file(\"logger-userdata.yml\")}"
}

resource "aws_instance" "stats" {
  instance_type   = "m4.large"
  ami             = "${lookup(var.aws_amis, var.aws_region)}"
  key_name        = "${var.key_name}"
  security_groups = ["${aws_security_group.cluster.name}", "${aws_security_group.external_connections.name}", "${aws_security_group.stats.name}"]

  tags {
      Name = "stats"
  }

  user_data = "${file(\"stats-userdata.yml\")}"
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "elb" {
  name        = "web_frontend"
  description = "Web Frontend load balancer"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_elb" "web" {
  name = "frontend-load-balancer"

  subnets         = ["${aws_subnet.default.id}"]
  security_groups = ["${aws_security_group.elb.id}"]
  instances       = ["${aws_instance.web.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

resource "aws_instance" "web" {
  connection {
    user = "ubuntu"
  }
  instance_type          = "m4.large"
  ami                    = "${lookup(var.aws_amis, var.aws_region)}"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.cluster.id}", "${aws_security_group.external_connections.id}"]
  subnet_id              = "${aws_subnet.default.id}"
}
