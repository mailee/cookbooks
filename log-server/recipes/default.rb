#
# Cookbook Name:: log-server
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'java'
include_recipe 'elasticsearch'
include_recipe 'logstash::server'
include_recipe 'kibana::default'
