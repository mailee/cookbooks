template File.join(node[:monit][:conf_dir], "unicorn.monitrc") do
  source "unicorn.monitrc.erb"
  mode 0644
end
