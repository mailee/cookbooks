#
# Cookbook Name:: mailee-links
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

config_file = "#{node[:nginx][:dir]}/sites-available/#{node[:deploy][:mailee_staging][:application]}"

if File.exists? config_file
  name = node["opsworks"]["applications"].first["slug_name"]
  @application = node["deploy"][name]
  template config_file do
    source "nginx-site.erb"
    owner "root"
    group "root"
    mode 0644
  end

  service 'nginx' do
    action [:reload]
    provider Chef::Provider::Service::Upstart
  end

end
