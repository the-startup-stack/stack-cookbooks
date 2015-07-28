#
# Cookbook Name:: stack-hosts
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

execute "Copy hosts file to tmp dir" do
  command "cp /etc/hosts /tmp/hostfile-#{Time.now.strftime('%m-%d-%y')}"
end

execute "Clean all previous chef entried" do
  command "sed -i '/# @6/d' /etc/hosts"
end

nodes = search(:node, '*:*')
nodes.each do |n|
  if node['fqdn'] != n['fqdn'] && n['ipaddress']
    hostsfile_entry n['ipaddress'] do
      hostname n['fqdn']
      aliases  [ n['hostname'], n['fqdn'].gsub('www.', '') ]
    end
  else
    hostsfile_entry '127.0.1.1' do
      hostname node['fqdn']
      aliases  [ node['hostname'] ]
    end
  end
end
