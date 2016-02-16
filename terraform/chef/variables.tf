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

variable "certificate_file" {
  description = "SSL certificate file provided by your DNS or certificate marketplace. eg: your-certificate.pem"
}

variable "certificate_key" {
  description = "SSL key file provided by your DNS or certificate marketplace. eg: your-certificate.key"
}
