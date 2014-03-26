require 'yaml'
#
# Cookbook Name:: maileed
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "git"
include_recipe 'python'
include_recipe 'redisio::install'
include_recipe 'redisio::enable'


execute "apt-get update"
package 'libpq-dev'
package 'libxml2-dev'
package 'libxslt-dev'


python_packages = ['psycopg2','lxml','pyyaml','daemon','lockfile','setproctitle','html2text','redis']

python_packages.each {|package| python_pip package }

user = `ls /home/`.split("\n")[0]

directory "/home/#{user}/.ssh" do
  owner user
  group user
  mode 00644
  action :create
  not_if { ::File.directory?("/home/#{user}/.ssh") }
end

file "/home/#{user}/.ssh/id_rsa" do
  owner user
  group user
  mode "0600"
  action :create
  content node['maileed']['ssh']['private_key']
  not_if { ::File.exists?("/home/#{user}/.ssh/id_rsa") }

end

file "/home/#{user}/.ssh/id_rsa.pub" do
  owner user
  group user
  mode "0644"
  action :create
  content node['maileed']['ssh']['public_key']
  not_if { ::File.exists?("/home/#{user}/.ssh/id_rsa.pub") }
end


git "/opt/maileed/" do
  repository "git@bitbucket.org:panop/maileed.git"
  revision "master"
  action :sync
end

file "/opt/maileed/config.yml" do
  mode "0644"
  action :create
  content YAML.dump(node['maileed'])
end
