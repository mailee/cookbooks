#
# Cookbook Name:: mailerq
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute

include_recipe "rabbitmq"
include_recipe "rabbitmq::mgmt_console"
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

when "centos","redhat", "amazon", "amazon_linux"
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

package "opendkim" do
  action :install
end

template "/etc/mailerq/config.txt" do
  source "config.txt.erb"
end

template "/etc/mailerq/license.txt" do
  source "license.txt.erb"
end

service "rabbitmq-server" do
  action :restart
end

cookbook_file "/usr/local/bin/rabbitmqadmin" do
  source "rabbitmqadmin"
  mode "0777"
  action :create
end



unless File.exists? "/etc/mailerq/setup_with_success"
  create_queue =  lambda { |queue, configs| "rabbitmqadmin #{configs.join(' ')} declare queue name=#{queue} durable=true auto_delete=false"}
  create_exchange = lambda { |exchange, configs| "rabbitmqadmin #{configs.join(' ')} declare exchange name=#{exchange} type=direct durable=true auto_delete=false"}
  bind_exchange_to_queue = lambda { |exchange, queue, configs| "rabbitmqadmin #{configs.join(' ')} declare binding source=#{exchange} destination=#{queue} routing_key=0"}
  queues = [ node['mailerq']['rabbitmq']['outbox'], node['mailerq']['rabbitmq']['failure'], node['mailerq']['rabbitmq']['retry'], node['mailerq']['rabbitmq']['success'] ]
  configs = ['-H', node['mailerq']['rabbitmq']['host'], '-P', 15672, '-V', node['mailerq']['rabbitmq']['vhost'] ]#, '-u', node['mailerq']['rabbitmq']['user'], '-p', node['mailerq']['rabbitmq']['password'] ]
  commands = queues.map {|q| create_queue.call(q, configs)}
  commands.concat queues.map{|q| create_exchange.call(q, configs) }
  commands.concat queues.map{|q| bind_exchange_to_queue.call(q, q, configs) }
  commands << create_queue.call('failure_parse', configs)
  commands << bind_exchange_to_queue.call('failure', 'failure_parse', configs)
  commands << create_queue.call('received', configs)
  commands << bind_exchange_to_queue.call('outbox', 'received', configs)
  execute "configure rabbitmq" do
    puts "Executing RabbitMQ initial configuration"
    command commands.join("\n")
  end
  file "/etc/mailerq/setup_with_success" do
    action :touch
  end
end

service "opendkim" do
  action :restart
end


service "mailerq" do
  action :start
end


