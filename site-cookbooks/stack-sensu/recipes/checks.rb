sensu_check "redis_process" do
  command "check-procs.rb -p redis-server -C 1"
  handlers ["slack"]
  subscribers ["redis"]
  interval 300
end

sensu_check "unicorn_check" do
  command "check-http.rb -x SENSU -u http://localhost/test/health_check"
  handlers ["slack"]
  interval 60
  subscribers ["backend", "frontend", "web_staging", "web_dev", "web_mdev", "web_api"]
end

sensu_check "nginx_check" do
  command "check-http.rb -x SENSU -u http://localhost/nginx_status -t 2 --response-code 200"
  handlers ["slack"]
  interval 10
  subscribers ['nginx']
end

sensu_check "cron_check" do
  command "check-procs.rb -p cron -C 1"
  handlers ["default"]
  interval 60
  subscribers ["all"]
end

sensu_check "check_cpu_user" do
  # warn user CPU > 60% crit > 80%
  command "check-cpu.rb --user -c 80 -w 60"
  handlers ["default"]
  interval 60
  subscribers ["all"]
end

sensu_check "check_cpu_system" do
  # warn user CPU > 30% crit > 50%
  command "check-cpu.rb --system -c 90 -w 80"
  handlers ["default"]
  interval 60
  subscribers ["all"]
end

sensu_check "check_disk_usage" do
  command "check-disk.rb -c 95 -w 90"
  handlers ["slack"]
  interval 600
  subscribers ["all"]
end
