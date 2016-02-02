#
# Cookbook Name:: stack-mongodb
# Recipe:: default
#
# Copyright 2016, The Startup Stack
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


include_recipe 'chef-sugar::default'
include_recipe 'aws'

creds = data_bag_item("aws", "main")

if ec2?
  aws_ebs_raid 'data_volume_raid' do
    mount_point '/mnt'
    disk_count node['mongodb']['disk_count']
    disk_size node['mongodb']['disk_size']
    level 10
    filesystem 'ext4'
    disk_piops 3000
    disk_type "io1"
    action :auto_attach
    aws_access_key          creds['aws_access_key_id']
    aws_secret_access_key   creds['aws_secret_access_key']
  end
end

directory node['mongodb']['data_dir'] do
  recursive true
end

docker_service 'default' do
  action [:create, :start]
end

docker_image 'mongo' do
  tag 'latest'
  action :pull
end

docker_container 'mongodb' do
  repo 'mongo'
  tag 'latest'
  volumes [ "#{node['mongodb']['data_dir']}:/data/db" ]
end
