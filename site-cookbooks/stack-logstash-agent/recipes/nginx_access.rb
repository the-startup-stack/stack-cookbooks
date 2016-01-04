service "rsyslog" do
  provider Chef::Provider::Service::Upstart
  action :nothing
end

node['logstash-agent']['logs_locations'].each do |obj|
  template obj[:syslog_file_location] do
    source "syslog_watcher.erb"
    variables({
      access_log_location: obj[:log_location],
      logstash_server_name: node['logstash-agent']['logstash_server_location'],
      syslog_tag: obj[:tag],
      logstash_port: obj[:port]
    })
    notifies :restart, "service[rsyslog]"
  end
end
