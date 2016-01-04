# Log Location Structure
#
#
#
# logs_location structure
#
#    syslog_file_location: '/etc/rsyslog.d/22-nginx-access.conf',
#    log_location: '/mnt/data-store/html/stack/shared/log/stack_nginx_access.log',
#    tag: 'nginx-access',
#    port: '5544'
#

default['logstash-agent']['logstash_server_location'] = 'logstash'
default['logstash-agent']['logs_locations']           = []
