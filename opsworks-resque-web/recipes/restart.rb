service 'resque-web' do
  action [:stop, :start]
  provider Chef::Provider::Service::Upstart
end
