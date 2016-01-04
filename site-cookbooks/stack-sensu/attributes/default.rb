include_attribute 'sensu'

override['uchiwa']['version'] = '0.7.0-1'
override['sensu']['use_embedded_ruby'] = true
override['sensu']['rabbitmq']['host'] = 'sensu-production'
