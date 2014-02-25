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

case node[:platform]
when "ubuntu","debian"
  cookbook_file "/tmp/mailerq-0.7.4-x86_64.deb" do
    source "mailerq-0.7.4-x86_64.deb"
    mode "0644"
    action :create
  end

  dpkg_package "mailerq" do
    source "/tmp/mailerq-0.7.4-x86_64.deb"
    action :install
  end
when "centos"
  cookbook_file "/tmp/mailerq-0.7.4-x86_64.rpm" do
    source "mailerq-0.7.4-x86_64.rpm"
    mode "0644"
    action :create
  end

  yum_package "mailerq" do
    source "/tmp/mailerq-0.7.4-x86_64.rpm"
    action :install
  end
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
