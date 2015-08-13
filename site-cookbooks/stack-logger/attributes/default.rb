include_attribute 'java'
include_attribute 'elasticsearch'
include_attribute 'logstash'
include_attribute 'kibana'

default['logger']['disk_count']  = 5
default['logger']['disk_size']   = 1025
default['logger']['raid_level']  = 10
default['logger']['disk_piops']  = 3000
default['logger']['mount_point'] = '/mnt'

override['java']['jdk_version'] = '7'

override['elasticsearch'][:version]      = "1.4.1"
override['elasticsearch'][:filename]     = "elasticsearch-#{node.elasticsearch[:version]}.tar.gz"
override['elasticsearch'][:download_url] = [node.elasticsearch[:host], node.elasticsearch[:repository], node.elasticsearch[:filename]].join('/')
override['elasticsearch'][:path][:conf]  = "/usr/local/etc/elasticsearch"
override['elasticsearch'][:path][:data]  = "/mnt/data-store/elasticsearch/data"
override['elasticsearch'][:path][:logs]  = "/mnt/data-store/elasticsearch/log"

override['logstash']['instance']['default']['version']            = '1.4.2'
override['logstash']['instance']['default']['source_url']         = 'https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.tar.gz'
override['logstash']['instance']['default']['checksum']           = 'd59ef579c7614c5df9bd69cfdce20ed371f728ff'
override['logstash']['instance']['default']['plugins_version']    = '1.4.2'
override['logstash']['instance']['default']['plugins_source_url'] = 'https://download.elasticsearch.org/logstash/logstash/logstash-contrib-1.4.2.tar.gz'
override['logstash']['instance']['default']['plugins_checksum']   = '9903e487c8811ba4f396cfeb29e04e2a116bfce6'

override['kibana']['file']['url']      = 'https://download.elasticsearch.org/kibana/kibana/kibana-3.1.2.tar.gz'
override['kibana']['file']['version']  = '3.1.2' # must match version number of above
override['kibana']['file']['checksum'] = '480562733c2c941525bfa26326b6fae5faf83109b452a6c4e283a5c37e3086ee' # sha256 ( shasum -a 256 FILENAME )

# use single file for logstash config
override['logstash']['instance']['server']['config_templates_cookbook'] = 'stack-logger'
override['logstash']['instance']['server']['config_templates']          = {
  'syslog' => 'config/syslog_config.conf.erb',
  'rails' => 'config/rails_config.conf.erb',
}

override['logstash']['instance']['default']['config_templates_cookbook'] = 'stack-logger'
override['logstash']['instance']['default']['config_templates']          = {
  'empty_config' => 'config/empty_config.conf.erb'
}
