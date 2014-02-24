#
# Cookbook Name:: mailerq
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute

include_recipe "rabbitmq"
include_recipe "sqlite"

package "opendkim" do
  action :install
end

cookbook_file "/tmp/mailerq-0.7.4-x86_64.deb" do
  source "mailerq-0.7.4-x86_64.deb"
  mode "0644"
  action :create
end

dpkg_package "mailerq" do
  source "/tmp/mailerq-0.7.4-x86_64.deb"
  action :install
end

template "/etc/mailerq/config.txt" do
  source "config.txt.erb"
end

template "/etc/mailerq/license.txt" do
  source "license.txt.erb"
end

service "mailerq" do
  action :restart
end
