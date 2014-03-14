
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

case node[:platform]
when "ubuntu","debian"
  apt_package "libpq" do
    action :install
  end
  apt_package "libpq-dev" do
    action :install
  end
when "centos","redhat", "amazon", "amazon_linux"
  cookbook_file "/tmp/postgresql93-libs-9.3rc1-1PGDG.rhel6.x86_64.rpm" do
    source "postgresql93-libs-9.3rc1-1PGDG.rhel6.x86_64.rpm"
    mode "0644"
    action :create
  end
  yum_package "postgresql93-libs" do
    source "/tmp/postgresql93-libs-9.3rc1-1PGDG.rhel6.x86_64.rpm"
    action :install
  end
  cookbook_file "/tmp/postgresql93-9.3rc1-1PGDG.rhel6.x86_64.rpm" do
    source "postgresql93-9.3rc1-1PGDG.rhel6.x86_64.rpm"
    mode "0644"
    action :create
  end
  yum_package "postgresql93-client" do
    source "/tmp/postgresql93-9.3rc1-1PGDG.rhel6.x86_64.rpm"
    action :install
  end
  cookbook_file "/tmp/postgresql93-devel-9.3rc1-1PGDG.rhel6.x86_64.rpm" do
    source "postgresql93-devel-9.3rc1-1PGDG.rhel6.x86_64.rpm"
    mode "0644"
    action :create
  end
  yum_package "postgresql93-devel" do
    source "/tmp/postgresql93-devel-9.3rc1-1PGDG.rhel6.x86_64.rpm"
    action :install
  end
  execute "add pg_config to PATH" do
    command "echo 'PATH=$PATH:/usr/pgsql-9.3/bin' >> /etc/bashrc"
  end

  # lets make some black magic to install node-gyp
  # according to https://github.com/TooTallNate/node-gyp/issues/363
  execute "move python gyp" do
    command "mv `python -c 'import gyp; print gyp.__file__'` `python -c 'import gyp; print gyp.__file__'`_backup"
  end
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