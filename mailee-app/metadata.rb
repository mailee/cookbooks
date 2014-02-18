name             'mailee-app'
maintainer       'Pedro Axelrud'
maintainer_email 'pedroaxl@gmail.com'
license          'All rights reserved'
description      'Installs/Configures mailee-app'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'postgresql', '~> 3.3.0'
depends 'redisio', '~> 1.7.0'
depends 'rbenv', '~> 1.7.0'
depends 'bluepill', '~> 2.3.1'

