name             'maileed'
maintainer       'Pedro Axelrud'
maintainer_email 'pedroaxl@gmail.com'
license          'All rights reserved'
description      'Installs/Configures maileed'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'git'
depends 'python', '~> 1.4.6'
depends 'redisio', '~> 1.7.1'
depends 'dnsmasq', '~> 0.2.0'
