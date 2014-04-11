require 'yaml'

include_recipe "git"


user = `ls /home/`.split("\n")[0]

directory node['maileed']['deploy_dir'] do
  action :create
  owner user
  group user
  not_if { ::File.directory?(node['maileed']['deploy_dir']) }
end

git node['maileed']['deploy_dir'] do
  repository node['maileed']['repo']
  revision "master"
  action :sync
  user user
end

directory node['maileed']['pid_dir'] do
  action :create
  owner user
  group user
  not_if { ::File.directory?(node['maileed']['pid_dir']) }
end

config = {
  'db' => node['maileed']['database'].to_hash,
  'options' => node['maileed']['options'].to_hash,
  'redis' => node['maileed']['redis'].to_hash
}

file "#{node['maileed']['deploy_dir']}/config.yml" do
  mode "0644"
  action :create
  content YAML::dump(config)
end

file "#{node['maileed']['deploy_dir']}/dkim.key" do
  mode "0644"
  action :create
  content node['maileed']['dkim_private_key']
end

execute "pip install -r requirements.txt" do
  cwd node['maileed']['deploy_dir']
end

service 'maileed' do
  action [:stop, :start]
  provider Chef::Provider::Service::Upstart
end
