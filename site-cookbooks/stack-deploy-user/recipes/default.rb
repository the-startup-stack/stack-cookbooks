#
# Cookbook Name:: stack-deploy-user
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

include_recipe "users"

deploy_path = node['rails']['deploy']['path']
directory deploy_path do
  action :create
  recursive true
end

group node['rails']['deploy']['group'] do
  gid node['rails']['deploy']['gid']
  action :create
end

users_manage node['rails']['deploy']['owner'] do
  group_id node['rails']['deploy']['gid']
  group_name node['rails']['deploy']['group']
  search_group node['rails']['deploy']['group']
  action [:create, :remove]
end


file "/etc/sudoers.d/99-stack-deploy" do
  content "#{node['rails']['deploy']['owner']} ALL=(ALL) NOPASSWD:ALL"
  owner 'root'
  group 'root'
  mode  '0440'
  action :create
end
