#
# Cookbook Name:: stack-ruby-webserver
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
#

include_recipe 'stack-ruby'
include_recipe "stack-nginx"
include_recipe "stack-mysql::client" # for mysql2 gem, If you are using PG, you don't need this recipe
include_recipe "stack-logstash-agent::nginx_access"
include_recipe "stack-packages"
include_recipe "stack-deploy-user"

deploy_path = node['rails']['deploy']['path']

# create deploy paths
[ deploy_path,
  File.join(deploy_path, 'releases'),
  File.join(deploy_path, 'shared'),
  File.join(deploy_path, 'shared/bin'),
  File.join(deploy_path, 'shared/log'),
  File.join(deploy_path, 'shared/sitemaps'),
  File.join(deploy_path, 'shared/system'),
  File.join(deploy_path, 'shared/pids'),
  File.join(deploy_path, 'shared/god'),
  '/var/run/unicorn' # for unicorn sockets
].each { |dir|
  directory dir do
    owner node['rails']['deploy']['owner']
    group node['rails']['deploy']['group']
    recursive true
  end
}

# set rails environment for all users on server
file "/etc/profile.d/rails_env.sh" do
  content "export RAILS_ENV=#{node['rails']['deploy']['environment']}"
  mode  '0755'
  owner node['rails']['deploy']['owner']
  group node['rails']['deploy']['group']
end

include_recipe "stack-god" # For centralized god installation

template "/etc/init.d/unicorn" do
  source 'unicorn_initd.sh.erb'
  owner  'root'
  group  'root'
  mode   '0755'
  variables({
    ruby_version: node['rails']['deploy']['rvm'],
    rails_root: "#{node['rails']['deploy']['path']}/current",
    rails_environment: node['rails']['deploy']['environment'],
    socket_folder: node['rails']['deploy']['socket_folder'],
    deploy_owner: node['rails']['deploy']['owner'],
    shared_god_root: "#{node['rails']['deploy']['path']}/shared/god"
  })
end

service "unicorn" do
  provider Chef::Provider::Service::Init::Debian
  action :enable
end
unicorn_bundle_wrap = "#{node['rails']['deploy']['path']}/shared/bin/unicorn_bundle_wrap.rb"

template "#{node['rails']['deploy']['path']}/shared/bin/unicorn.sh" do
  source 'unicorn_wrapper.erb'
  owner node['rails']['deploy']['owner']
  group node['rails']['deploy']['group']
  mode  '755'
  variables({
    ruby_version: node['rails']['deploy']['rvm'],
    unicorn_bundle_wrap: unicorn_bundle_wrap
  })
end

template unicorn_bundle_wrap do
  source 'unicorn_bundle_wrap.erb'
  owner node['rails']['deploy']['owner']
  group node['rails']['deploy']['group']
  mode  '755'
end

template "#{node['rails']['deploy']['path']}/shared/unicorn.rb" do
  source 'unicorn.rb.erb'
  owner node['rails']['deploy']['owner']
  group node['rails']['deploy']['group']
  mode '755'
  variables({
    worker_processes: node['rails']['deploy']['worker_processes'],
    worker_timeout: node['rails']['deploy']['worker_timeout'],
    socket_location: node['rails']['deploy']['socket_location'],
    backlog: node['rails']['deploy']['backlog'],
    path: node['rails']['deploy']['path']
  })
end

template "#{node['rails']['deploy']['path']}/shared/env.sh" do
  source 'env.sh.erb'
  owner node['rails']['deploy']['owner']
  group node['rails']['deploy']['group']
  mode  '755'
  variables({
    ruby_version: node['rails']['deploy']['rvm'],
  })
end

template "/etc/nginx/sites-available/stack.conf" do
  source 'stack-nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '755'
  variables({
    socket_location: node['rails']['deploy']['socket_location'],
    path: node['rails']['deploy']['path'],
    web_dynamic: node['rails']['deploy']['web_dynamic'],
    web_static:  node['rails']['deploy']['web_static'],
    web_health:  node['rails']['deploy']['web_health'],
    web_cdn:     node['rails']['deploy']['web_cdn']
  })
  notifies :restart, 'service[nginx]'
end


link "/etc/nginx/sites-enabled/stack.conf" do
  to "/etc/nginx/sites-available/stack.conf"
end
