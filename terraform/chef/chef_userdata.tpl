#cloud-config

bootcmd:
 - echo 127.0.1.1 chef >> /etc/hosts
 - hostname chef.${domain_name}

preserve_hostname: true
