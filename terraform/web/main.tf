module "base" {
  source = "../base"
  your_ip_address = "${var.your_ip_address}"
}

provider "aws" {
    region = "${var.aws_region}"
}

resource "aws_elb" "web" {
  name = "terraform-example-elb"

  subnets         = ["${module.web_base.default_subnet_id}"]
  security_groups = ["${module.web_base.default_elb_security_group_id}", "${module.base.external_connections_security_group_id}"]
  instances       = ["${aws_instance.web.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

resource "aws_instance" "web" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    # The default username for our AMI
    user = "ubuntu"

    # The connection will use the local SSH agent for authentication.
  }

  instance_type = "m4.large"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.aws_amis, var.aws_region)}"

  # The name of our SSH keypair we created above.
  key_name = "stack-prod"

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${module.web_base.default_security_group_id}"]

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id = "${module.web_base.default_subnet_id}"

  # We run a remote provisioner on the instance after creating it.
  # In this case, we just install nginx and start it. By default,
  # this should be on port 80
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo service nginx start"
    ]
  }
}
