#
# Cookbook Name:: stack-sensu
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

include_recipe 'sensu'
include_recipe 'sensu::rabbitmq'
include_recipe 'sensu::redis'
include_recipe 'sensu::server_service'
include_recipe 'sensu::api_service'
include_recipe 'uchiwa'
include_recipe cookbook_name.to_s

include_recipe "#{cookbook_name}::checks"

# sensu_handler "graphite" do
#   type
# end

# sensu_handler "email" do
#   type "email"
#   command "..."
#   severities ["ok", "critical"]
# end

# sensu_filter "environment" do
#   attributes(:client => {:environment => "development"})
#   negate true
# end

# sensu_mutator "opentsdb" do
#   command "opentsdb.rb"
# end
#

data = data_bag_item('sensu', 'credentials').raw_data
slack = data['slack']

## Config for Slack notification
#
# "webhook_url": "webhook url",
# "channel": "#notifications-room, optional defaults to slack defined",
# "message_prefix": "optional prefix - can be used for mentions",
# "surround": "optional - can be used for bold(*), italics(_), code(`) and preformatted(```)",
# "bot_name": "optional bot name, defaults to slack defined",
# "proxy_addr": "optional - your proxy address for http proxy, like squid, i.e. 192.168.10.100",
# "proxy_port": "optional - should be port used by proxy, i.e. 3128",
# "markdown_enabled": false
#
sensu_snippet "slack" do
  content(
    message_prefix: "avi,kensodev,netta,eduardosasso,eduardo,ori",
    webhook_url: slack['webhook_url'],
    channel: slack['channel'],
    team_name: slack['team_name'],
    bot_name: slack['bot_name']
  )
end
