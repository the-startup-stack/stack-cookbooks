#
# Cookbook Name:: stack-zookeeper
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

zookeeper '3.4.6' do
  user     'zookeeper'
  mirror   'http://www.poolsaboveground.com/apache/zookeeper'
  checksum '01b3938547cd620dc4c93efe07c0360411f4a66962a70500b163b59014046994'
  action   :install
end

config_hash = {
  'initLimit' => 5,
  'syncLimit' => 2,
  'clientPort' => 2181,
  'dataDir' => '/opt/zookeeper/zookeeper-3.4.6/data',
  'tickTime' => 2000
}

zookeeper_config '/opt/zookeeper/zookeeper-3.4.6/conf/zoo.cfg' do
  config config_hash
  user   'zookeeper'
  action :render
end

include_recipe 'zookeeper::service'
