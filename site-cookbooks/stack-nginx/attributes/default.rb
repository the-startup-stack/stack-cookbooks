include_attribute 'nginx'

# In order to find the latest stable version go here:
# https://launchpad.net/~nginx/+archive/ubuntu/stable
# @KensoDev
override['nginx']['version'] = "1.8.0-1+#{node['lsb']['codename']}1"
override['nginx']['install_method'] = 'package'
override['nginx']['default_site_enabled'] = false
