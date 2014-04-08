include_recipe "build-essential"
include_recipe "openssl"
include_recipe "postgresql::server"
include_recipe "postgresql::contrib"
include_recipe "postgresql::pg_user"
include_recipe "postgresql::pg_database"
include_recipe "postgresql::libpq"
include_recipe "rabbitmq"
include_recipe "rabbitmq::mgmt_console"

unless File.exists? "/tmp/db_setup"

  pg_user "mailee" do
    privileges superuser: true, createdb: true, login: true
    password "1234"
  end

  ["mailer", "pedro"].each do |user|
    pg_user user do
      privileges superuser: false, createdb: false, login: true
      password "1234"
    end
  end


  pg_database "mailee_test" do
    owner "mailee"
    encoding "utf8"
    locale "en_US.UTF-8"
  end

  pg_database_extensions "mailee_test" do
    extensions ["hstore"]
  end

  execute "pg_restore" do
    user "postgres"
    command "pg_restore -d mailee_test -j 2 /vagrant/mailee_test.dump > /tmp/dump_restored"
  end
  file "/tmp/db_setup" do
    action :touch
  end
end

cookbook_file "/usr/local/bin/rabbitmqadmin" do
  source "rabbitmqadmin"
  mode "0777"
  action :create
end



unless File.exists? "/tmp/rabbitmq_setup"
  create_queue =  lambda { |queue, configs| "rabbitmqadmin #{configs.join(' ')} declare queue name=#{queue} durable=true auto_delete=false"}
  create_exchange = lambda { |exchange, configs| "rabbitmqadmin #{configs.join(' ')} declare exchange name=#{exchange} type=direct durable=true auto_delete=false"}
  bind_exchange_to_queue = lambda { |exchange, queue, configs| "rabbitmqadmin #{configs.join(' ')} declare binding source=#{exchange} destination=#{queue} routing_key=0"}
  queues = [ 'outbox', 'failure','retries', 'success' ]
  configs = ['-H', 'localhost', '-P', 15672, '-V', '/' ]
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
  file "/tmp/rabbitmq_setup" do
    action :touch
  end
end
