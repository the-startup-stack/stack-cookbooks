name             'stack-marathon'
maintainer       'The Startup Stack'
maintainer_email 'avi@avi.io'
license          'MIT'
description      'Installs/Configures stack-marathon'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.26'

depends 'apt'
depends 'stack-java'
depends 'chef-sugar'
