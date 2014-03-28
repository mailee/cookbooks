#
# Cookbook Name:: maileed
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'python'
include_recipe 'redisio::install'
include_recipe 'redisio::enable'
include_recipe 'dnsmasq::dns'
include_recipe 'bluepill'


execute "apt-get update"
package 'libpq-dev'
package 'libxml2-dev'
package 'libxslt-dev'


python_packages = ['psycopg2','lxml','pyyaml','daemon','lockfile','setproctitle','html2text','redis']

python_packages.each {|package| python_pip package }

gem_package "bluepill"
