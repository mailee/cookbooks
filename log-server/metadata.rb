name             'log-server'
maintainer       'YOUR_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures log-server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'java', '~> 1.19.2'
depends 'elasticsearch', '~> 0.3.7'
depends 'logstash', '~> 0.5.9'
depends 'kibana', '~> 0.1.6'
