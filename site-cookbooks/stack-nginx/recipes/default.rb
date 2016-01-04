#
# Cookbook Name:: stack-nginx
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

# add Nginx PPA; grab key from keyserver
apt_repository 'nginx-stable' do
  uri 'http://ppa.launchpad.net/nginx/stable/ubuntu'
  distribution node['lsb']['codename']
  components ['main']
  keyserver 'keyserver.ubuntu.com'
  key 'C300EE8C'
end

# upstart nginx init script
node.set['nginx']['daemon_disable']  = node['nginx']['upstart']['foreground']
template '/etc/init/nginx.conf' do
  source 'nginx-upstart.conf.erb'
  cookbook 'nginx'
  owner 'root'
  group 'root'
  mode  '0644'
  action :create
  variables(
    src_binary:    node['nginx']['binary'],
    pid:           node['nginx']['pid'],
    config:        node['nginx']['source']['conf_path'],
    foreground:    node['nginx']['upstart']['foreground'],
    respawn_limit: node['nginx']['upstart']['respawn_limit'],
    runlevels:     node['nginx']['upstart']['runlevels']
  )
end

# upstart nginx service
service 'nginx' do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true, :reload => true
  action :nothing
end

# include OpsCode recipe before modifying it
include_recipe "nginx"

file '/etc/init.d/nginx' do
  action :nothing
end

execute 'remove init.d nginx start script' do
  command 'update-rc.d -f nginx remove'
  only_if { File.exists? '/etc/init.d/nginx' }
  notifies :delete, 'file[/etc/init.d/nginx]', :immediately
end

# modify nginx package name to include version
begin
  r = resources("package[#{node['nginx']['package_name']}]")
  Chef::Log.info "Modifying package[#{node['nginx']['package_name']}."
  r.instance_exec do
    version "#{node['nginx']['version']}" if node['nginx']['version']
    notifies :run, 'execute[remove init.d nginx start script]', :immediately
    action :install
  end
rescue Chef::Exception::ResourceNotFound => e
  Chef::Log.info "Resource package[#{node['nginx']['package_name']}] not found. #{e}"
end

# don't create the ohai nginx.rb file
begin
  r = resources("template[#{node['ohai']['plugin_path']}/nginx.rb]")
  Chef::Log.info "Modifying package[#{node['nginx']['package_name']}."
  r.instance_exec do
    action :nothing
  end
rescue Chef::Exception::ResourceNotFound => e
end

service 'nginx' do
  action :start
end
