require 'yaml'

include_recipe "git"

user = `ls /home/`.split("\n")[0]

template '/etc/bluepill/maileed.pill' do
  source 'maileed.pill.erb'
end

git node['maileed']['deploy_dir'] do
  repository "git@bitbucket.org:panop/maileed.git"
  revision "master"
  action :sync
  user user
end

directory node['maileed']['pid_dir'] do
  action :create
  user user
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

bluepill_service 'maileed' do
  action [:stop]
end


bluepill_service 'maileed' do
  action [:enable, :load, :start]
end
