#
# Cookbook Name:: odes
# Recipe:: planet
#

package 'python-pip'

python_pip 'awscli' do
  version node[:mapzen_odes][:awscli][:version]
end

execute 'download planet' do
  user      node[:mapzen_odes][:user][:id]
  cwd       node[:mapzen_odes][:setup][:basedir]
  command   "aws s3 cp s3://#{node[:mapzen_odes][:planet][:url]}/#{node[:mapzen_odes][:planet][:file]}"

  not_if    { ::File.exist?("#{node[:mapzen_odes][:setup][:basedir]}/#{node[:mapzen_odes][:planet][:file]}") }

  notifies  :run, 'execute[osmconvert planet]', :immediately
end

execute 'osmconvert planet' do
  action  :nothing
  user    node[:mapzen_odes][:user][:id]
  cwd     node[:mapzen_odes][:setup][:basedir]
  timeout node[:mapzen_odes][:osmconvert][:timeout]
  command <<-EOH
    osmconvert #{node[:mapzen_odes][:planet][:file]} -o=planet.o5m \
      >#{node[:mapzen_odes][:setup][:basedir]}/logs/osmconvert_planet.log 2>&1
  EOH
end

# cron
template "#{node[:mapzen_odes][:setup][:scriptsdir]}/update_planet.sh" do
  owner   node[:mapzen_odes][:user][:id]
  mode    0755
  source  'update_planet.sh.erb'
end

cron 'update planet' do
  command "#{node[:mapzen_odes][:setup][:scriptsdir]}/update_planet.sh >#{node[:mapzen_odes][:setup][:basedir]}/logs/update_planet.log 2>&1"
  user    node[:mapzen_odes][:user][:id]
  home    node[:mapzen_odes][:setup][:basedir]
  hour    '5'
  minute  '*'
  weekday '*'
end
