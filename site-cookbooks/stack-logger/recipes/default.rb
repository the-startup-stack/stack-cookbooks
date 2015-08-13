#
# Cookbook Name:: stack-logger
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
include_recipe 'aws'

creds = data_bag_item("aws", "main")

aws_ebs_raid 'data_volume_raid' do
  mount_point node['logger']['mount_point']
  disk_count node['logger']['disk_count']
  disk_size node['logger']['disk_size']
  level node['logger']['raid_level']
  filesystem 'ext4'
  disk_piops node['logger']['disk_piops']
  disk_type "io1"
  hvm true
  action :auto_attach
  aws_access_key          creds['aws_access_key_id']
  aws_secret_access_key   creds['aws_secret_access_key']
end

include_recipe 'htpasswd'
include_recipe 'java'
include_recipe 'elasticsearch'
include_recipe 'logstash::server'

htpasswd "#{node['nginx']['dir']}/htpassword" do
  user data_bag_item('kibana', 'credentials')['user']
  password data_bag_item('kibana', 'credentials')['password']
end

if node['kibana']['user'].empty?
  if !node['kibana']['webserver'].empty?
    webserver = node['kibana']['webserver']
    kibana_user = node[webserver]['user']
  else
    kibana_user = 'nobody'
  end
else
  kibana_user = node['kibana']['user']
  kibana_user kibana_user do
    name kibana_user
    group kibana_user
    home node['kibana']['install_dir']
    action :create
  end
end

kibana_install 'kibana' do
  user kibana_user
  group kibana_user
  install_dir node['kibana']['install_dir']
  install_type node['kibana']['install_type']
  action :create
end

template "#{node['kibana']['install_dir']}/current/config.js" do
  source node['kibana']['config_template']
  cookbook node['kibana']['config_cookbook']
  mode '0750'
  user kibana_user
end

link "#{node['kibana']['install_dir']}/current/app/dashboards/default.json" do
  to 'logstash.json'
  only_if { !File.symlink?("#{node['kibana']['install_dir']}/current/app/dashboards/default.json") }
end

kibana_web 'kibana' do
  template_cookbook 'logger-cookbook'
  type node['kibana']['webserver']
  docroot "#{node['kibana']['install_dir']}/current"
  es_server node['kibana']['es_server']
  not_if { node['kibana']['webserver'].empty? }
end
