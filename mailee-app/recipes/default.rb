#
# Cookbook Name:: mailee-app
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"
include_recipe "rbenv::rbenv_vars"
include_recipe "bluepill"

execute "postgres: create user mailee" do
    code = <<-EOH
    psql -U postgres -c "select * from pg_user where usename='mailee'" | grep -c mailee
    EOH
    command "su - postgres -c 'createuser -s mailee'"
    not_if code
end


execute "postgres: create database mailee_development" do
    exists = <<-EOH
    psql -U postgres -c "select * from pg_database WHERE datname='mailee_development'" | grep -c mailee_development
    EOH
    command "createdb -U mailee -O mailee -E utf8 mailee_development"
    not_if exists
end

package "libsqlite3-dev"
rmagick_dependencies = %w{imagemagick libmagickcore-dev libmagickcore5 librmagick-ruby graphicsmagick imagemagick-common libmagick++-dev}
rmagick_dependencies.each{|d| package d }

rbenv_ruby "1.9.2-p320" do
  ruby_version "1.9.2-p320"
  global true
end

rbenv_gem "bundler" do
  ruby_version "1.9.2-p320"
end

template '/etc/bluepill/mailee.pill' do
  source 'mailee.pill.erb'
end

bluepill_service 'mailee' do
  action [:enable, :load, :start]
end

link "/usr/local/bin/bluepill" do
  to "/opt/rbenv/shims/bluepill"
end

