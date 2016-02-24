variable "your_ip_address" {
    description = "Your IP address, being used in order to SSH into the servers"
    default = "24.130.239.224"
}

variable "aws_region" {
    description = "AWS region to launch servers."
    default = "us-east-1"
}

variable "aws_amis" {
    default = {
        "us-east-1" = "ami-7ba59311"
    }
}

variable "key_name" {

}

variable "chef_username" {
  description = "Username for the main user on the chef server. eg: 'johndoe'"
}

variable "chef_user" {
  description = "The chef user. eg: 'John Doe'"
}

variable "chef_password" {
  description = "The chef password. eg: 'VerySecurePassword'"
}

variable "chef_user_email" {
  description = "The chef user email. eg: 'devops@your-domain.com'"
}

variable "chef_organization_id" {
  description = "The chef organization id. eg: 'yourcompany'"
}

variable "chef_organization_name" {
  description = "The chef organization name. eg: 'Your Company'"
}

variable "domain_name" {
  description = "Your domain name (without the www). eg: 'your-domain.com'"
}
