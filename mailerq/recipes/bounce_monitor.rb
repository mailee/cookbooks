
include_recipe "git"
include_recipe "nodejs::install_from_binary"
include_recipe "nodejs::npm"

git "/opt/mailerq_bounce_monitor" do
  repository "https://github.com/hpmta/mailerq_bounce_monitor.git"
  revision "master"
  action :sync
end

template "/opt/mailerq_bounce_monitor/database.json" do
  source "database.json.erb"
end

template "/opt/mailerq_bounce_monitor/rabbitmq.json" do
  source "rabbitmq.json.erb"
end


execute "npm install" do
  cwd "/opt/mailerq_bounce_monitor"
  command "npm install"
end


execute "enable rsyslog on 514 UDP" do
  command "echo '$ModLoad imudp\n$UDPServerRun 514' >> /etc/rsyslog.conf"
  not_if "cat /etc/rsyslog.conf | grep -P '^\$ModLoad imudp'"
end

service "rsyslog" do
  action :stop
end
service "rsyslog" do
  action :start
end

template "/etc/monit.d/bounce_monitor.monitrc" do
  source "bounce_monitor.monitrc"
  not_if { ::File.directory?('/etc/monit.d') }
end
service "monit" do
  action :restart
  not_if { ::File.directory?('/etc/monit.d') }
end



service "mailerq" do
  action :restart
end