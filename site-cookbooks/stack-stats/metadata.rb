name             'stack-stats'
maintainer       'The Startup Stack'
maintainer_email 'avi@avi.io'
license          'MIT'
description      'Installs/Configures stack-stats'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'graphite'
depends 'statsd'
depends 'collectd'
depends 'aws'
