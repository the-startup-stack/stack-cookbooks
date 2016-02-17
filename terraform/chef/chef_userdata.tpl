#cloud-config

bootcmd:
 - hostname chef.${domain_name}

preserve_hostname: true
