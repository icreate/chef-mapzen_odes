#
# Cookbook Name:: mapzen_odes
# Recipe:: planet
#

package 'python-pip'

python_pip 'awscli' do
  version node[:mapzen_odes][:awscli][:version]
end

execute 'download planet' do
  user      node[:mapzen_odes][:user][:id]
  cwd       "#{node[:mapzen_odes][:setup][:basedir]}/data"
  command   "aws s3 cp s3://#{node[:mapzen_odes][:planet][:url]} ."

  not_if    { ::File.exist?("#{node[:mapzen_odes][:setup][:basedir]}/data/#{node[:mapzen_odes][:planet][:file]}") }

  notifies :run, 'execute[initial planet update]', :immediately
  notifies :run, 'execute[osmconvert planet]', :immediately
end

# update the planet if this is the initial setup run
execute 'initial planet update' do
  action      :nothing
  user        node[:mapzen_odes][:user][:id]
  cwd         "#{node[:mapzen_odes][:setup][:basedir]}/data"
  timeout     node[:mapzen_odes][:planet_update][:timeout]
  retries     2
  retry_delay 60
  command <<-EOH
    osmupdate #{node[:mapzen_odes][:planet][:file]} \
      updated-#{node[:mapzen_odes][:planet][:file]} \
      >#{node[:mapzen_odes][:setup][:basedir]}/logs/osmupdate_planet.log 2>&1 &&
    rm #{node[:mapzen_odes][:planet][:file]} &&
    mv updated-#{node[:mapzen_odes][:planet][:file]} #{node[:mapzen_odes][:planet][:file]}
  EOH
  only_if { node[:mapzen_odes][:planet_update][:run] == true }
end

execute 'osmconvert planet' do
  action :nothing
  user   node[:mapzen_odes][:user][:id]
  cwd    "#{node[:mapzen_odes][:setup][:basedir]}/data"
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
  action  node[:mapzen_odes][:planet_update][:cron] == true ? :create : :delete
  command "#{node[:mapzen_odes][:setup][:scriptsdir]}/update_planet.sh >#{node[:mapzen_odes][:setup][:basedir]}/logs/update_planet.log 2>&1"
  user    node[:mapzen_odes][:user][:id]
  home    "#{node[:mapzen_odes][:setup][:basedir]}/data"
  hour    '14'
  minute  '*'
  weekday '*'
end
