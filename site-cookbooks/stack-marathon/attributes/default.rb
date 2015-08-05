default['mesosphere']['codename']             = node['lsb']['codename']
default['mesosphere']['distro']               = node['lsb']['id'].downcase
default['mesosphere']['apt']['url']           = "http://repos.mesosphere.com/#{default['mesosphere']['distro']}"
default['mesosphere']['apt']['key']           = 'E56151BF'
default['mesosphere']['zookeeper']['id']      = '1'
default['mesosphere']['zookeeper']['servers'] = [
  'mesos' # Main server
]
