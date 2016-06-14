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

attach_dir   = node['logger']['install_dir']
logstash_dir = "/mnt/logstash"
creds        = data_bag_item("aws", "main")
credentials  = data_bag_item('docker', 'credentials').raw_data
docker_repo = node['logger']['docker_repo']

docker_service 'default' do
  action [:create, :start]
end

docker_registry 'https://index.docker.io/v1/' do
  username credentials['username']
  email credentials['email']
  password credentials['password']
end

directory "#{attach_dir}/data" do
  mode '0755'
  recursive true
end

directory logstash_dir do
  mode '0755'
  recursive true
end

template "#{logstash_dir}/logstash.conf" do
  source "config/logstash-config.conf.erb"
  mode '0750'
end

docker_image 'kibana' do
  tag '4.5'
  action :pull
  notifies :redeploy, 'docker_container[kibana]'
end

docker_image 'elasticsearch' do
  tag '2.3'
  action :pull
  notifies :redeploy, 'docker_container[elasticsearch]'
end

docker_container 'elasticsearch' do
  repo 'elasticsearch'
  tag '2.3'
  volumes [ "#{attach_dir}/data:/usr/share/elasticsearch/data" ]
end

docker_image 'logstash' do
  repo "#{docker_repo}/logstash"
  tag 'latest'
  action :pull
  notifies :redeploy, 'docker_container[logstash]'
end

docker_container 'logstash' do
  repo "#{docker_repo}/logstash"
  tag 'latest'
  port "5000:5000"
  links ['elasticsearch:elasticsearch']
  command "logstash -f /opt/logstash/server/etc/conf.d/"
end

docker_container 'kibana' do
  repo 'kibana'
  tag '4.5'
  port "5601:5601"
  links ['elasticsearch:elasticsearch']
end

docker_image 'nginx' do
  repo "#{docker_repo}/kibana-nginx"
  tag 'latest'
  action :pull
  notifies :redeploy, 'docker_container[nginx]'
end

docker_container 'nginx' do
  repo "#{docker_repo}/kibana-nginx"
  tag 'latest'
  port "80:80"
  links ['kibana:kibana']
end
