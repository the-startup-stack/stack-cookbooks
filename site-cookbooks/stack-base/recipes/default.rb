#
# Cookbook Name:: stack-base
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
include_recipe 'ntp'
include_recipe 'ohai'
include_recipe 'ulimit'
include_recipe 'openssh'

# remove ubuntu/canonical services
%w{ apparmor whoopsie popularity-contest landscape-common }.each do |pkg|
  service pkg do
    action [ :stop, :disable ]
    ignore_failure true
  end
  package pkg do
    action [ :purge ]
    ignore_failure true
    notifies :run, 'execute[apt-get autoremove]'
  end
end

# no console for virtual servers
%w{ tty1 tty2 tty3 tty4 tty5 tty6 }.each do |tty|
  service tty do
    provider Chef::Provider::Service::Upstart
    action [ :stop ] # :disable doesn't work properly
    ignore_failure true
  end
  file "/etc/init/#{tty}.conf" do
    action :delete
    ignore_failure true
  end
end

# install useful packages
%w{ curl htop lsof sysstat tmux mailutils vim }.each do |pkg|
  package pkg
end

# add github and bitbucket as a system-wide known ssh hosts
ssh_known_hosts_entry 'github.com'
ssh_known_hosts_entry 'bitbucket.org'
