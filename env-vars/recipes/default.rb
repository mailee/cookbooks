node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  execute "restart Rails app #{application}" do
    cwd deploy[:current_path]
    command node[:opsworks][:rails_stack][:restart_command]
    action :nothing
  end

  Chef::Log.info 'Setting environment variables'

  deploy[:env_vars].each do |name, value|
    ENV["#{name}"] = "#{value}"
  end

  template "/etc/environment" do
    source "environment.erb"
    mode "0644"
    owner "root"
    group "root"
    variables({
      :env_vars => deploy[:env_vars]
    })
  end

  template "/usr/local/bin/environment.sh" do
    source "environment.sh.erb"
    mode "0755"
    owner "root"
    group "root"
    variables({
      :env_vars => deploy[:env_vars]
    })
  end

  execute "/usr/local/bin/environment.sh" do
    user "root"
    action :run
  end
end
