sensu_client node.name do
  address node.ipaddress
  subscriptions node.roles + ["all"]
  additional(:cluster => node.cluster)
end

sensu_check "redis_process" do
  command "check-procs.rb -p redis-server -C 1"
  handlers ["default"]
  subscribers ["redis"]
  interval 30
  additional(:notification => "Redis is not running", :occurrences => 5)
end
