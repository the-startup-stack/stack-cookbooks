name             'stack-mongodb'
maintainer       'The Startup Stack'
maintainer_email 'avi@avi.io'
license          'MIT'
description      'Installs/Configures stack-mongodb'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.3'

depends 'docker', '~> 2.0'
depends 'chef-sugar'
depends 'aws'
