variable "key_name" {
    description = "Name of the SSH keypair to use in AWS."
}

variable "your_ip_address" {
    description = "Your IP address, being used in order to SSH into the servers"
}

variable "aws_region" {
    description = "AWS region to launch servers."
    default = "us-west-2"
}

variable "aws_amis" {
    default = {
        "us-west-2" = "ami-7f675e4f"
    }
}
