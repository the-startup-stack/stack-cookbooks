#cloud-config

bootcmd:
 - hostname chef.${domain_name}
 - echo 127.0.1.1 chef chef.${domain_name} >> /etc/hosts
 - echo chef.${domain_name} > /etc/hostname

preserve_hostname: true
