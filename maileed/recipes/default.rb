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


execute "apt-get update"
package 'libpq-dev'
package 'libxml2-dev'
package 'libxslt-dev'


python_packages = ['psycopg2','lxml','pyyaml','daemon','lockfile','setproctitle','html2text','redis','pika']

python_packages.each {|package| python_pip package }

upstart_scripts = ['maileed.conf', 'maileed-master.conf', 'maileed-senders.conf', 'maileed-sender.conf','maileed-senders-stop.conf']

upstart_scripts.each do |script|
  template "/etc/init/#{script}" do
    source "upstart/#{script}.erb"
    mode "0755"
  end
end
