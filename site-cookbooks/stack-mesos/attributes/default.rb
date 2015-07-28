override[:mesos][:master] = {
  :port    => "5050",
  :log_dir => "/var/log/mesos",
  :zk      => "zk://zk1:2181/mesos",
  :cluster => "productionCluster",
  :quorum  => "1"
}
