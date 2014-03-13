name             'mailerq'
maintainer       'Pedro Axelrud'
maintainer_email 'pedroaxl@gmail.com'
license          'All rights reserved'
description      'Installs/Configures mailerq'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.0'

depends 'rabbitmq', '~> 2.4.0'
depends 'sqlite', '~> 1.0.0'
depends 'git', '~> 3.1.0'
depends 'nodejs', '~> 1.3.0'

