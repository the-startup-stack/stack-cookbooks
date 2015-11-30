#
# Cookbook Name:: gogobot-sensu
# Recipe:: server
#
# Copyright 2014, Gogobot Ltd.
#
# All rights reserved - Do Not Redistribute
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
