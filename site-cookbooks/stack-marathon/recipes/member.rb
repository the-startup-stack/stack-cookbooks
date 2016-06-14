include_recipe 'apt'
include_recipe 'chef-sugar::default'

apt_repository 'mesosphere' do
  distribution node['lsb']['codename']
  components ['main']
  uri node['mesosphere']['apt']['url']
  key node['mesosphere']['apt']['key']
  keyserver 'keyserver.ubuntu.com'
  action :add
end

[:mesos].each do |package_name|
  package package_name.to_s do
    action :install
  end
end

["zookeeper", "mesos-master"].each do |service_name|
  service service_name do
    action [:enable, :stop]
  end
end

if vagrant?
  zookeeper_servers = ['192.168.88.10']
end

template "/etc/mesos/zk" do
  source 'zookeeper_config.erb'
  mode   '0755'
  variables({
    zookeepers: zookeeper_servers
  })
end

service "mesos-slave" do
  action [:enable, :restart]
end
