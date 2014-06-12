package "monit"

include_recipe "opsworks_agent_monit::service"

node[:deploy].each do |application, deploy|
  template File.join(node[:monit][:conf_dir], "#{application}_unicorn.monitrc") do
    source "unicorn.monitrc.erb"
    mode 0644
    variables(:deploy => deploy, :application => application)
    notifies :restart, resources(:service => "monit")
  end
end
