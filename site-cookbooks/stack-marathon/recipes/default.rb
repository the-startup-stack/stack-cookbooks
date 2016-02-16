#
# Cookbook Name:: stack-marathon
# Recipe:: default
#
# Copyright 2015, The Startup Stack
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
include_recipe 'apt'
include_recipe 'stack-java'

apt_repository 'mesosphere' do
  distribution node['lsb']['codename']
  components ['main']
  uri node['mesosphere']['apt']['url']
  key node['mesosphere']['apt']['key']
  keyserver 'keyserver.ubuntu.com'
  action :add
end

[:mesos, :marathon, :chronos].each do |package_name|
  package package_name.to_s do
    action :install
  end
end

package "marathon" do
  action :install
end

file '/etc/zookeeper/conf/myid' do
  content node['mesosphere']['zookeeper']['id']
end

template "/etc/zookeeper/conf/zoo.cfg" do
  source 'zoo.cfg.erb'
  mode   '0755'
  variables({
    zookeeper_servers: node['mesosphere']['zookeeper']['servers']
  })
end

["zookeeper", "mesos-master", "marathon", "chronos"].each do |service_name|
  service service_name do
    action [:enable, :restart]
  end
end
