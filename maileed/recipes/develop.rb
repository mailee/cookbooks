include_recipe "build-essential"
include_recipe "openssl"
include_recipe "postgresql::server"
include_recipe "postgresql::contrib"
include_recipe "postgresql::pg_user"
include_recipe "postgresql::pg_database"
include_recipe "postgresql::libpq"
include_recipe "rabbitmq"
include_recipe "rabbitmq::mgmt_console"

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
