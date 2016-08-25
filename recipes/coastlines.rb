#
# Cookbook Name:: mapzen_odes
# Recipe:: coastlines
#

# only used for the initial setup run, after which we rely on the cron job
#   to download new data weekly

water_polygons_dir = "#{node[:mapzen_odes][:setup][:basedir]}/data/#{node[:mapzen_odes][:coastlines][:water_polygons][:file]}".split('.zip').first
remote_file "#{node[:mapzen_odes][:setup][:basedir]}/data/#{node[:mapzen_odes][:coastlines][:water_polygons][:file]}" do
  owner       node[:mapzen_odes][:user][:id]
  mode        0644
  retries     10
  retry_delay 10
  backup      false
  source      node[:mapzen_odes][:coastlines][:water_polygons][:url]
  notifies    :run, 'execute[unzip water polygons]', :immediately
  not_if      { ::File.directory?(water_polygons_dir) }
end

execute 'unzip water polygons' do
  action  :nothing
  user    node[:mapzen_odes][:user][:id]
  cwd     "#{node[:mapzen_odes][:setup][:basedir]}/data"
  command "unzip -o #{node[:mapzen_odes][:coastlines][:water_polygons][:file]}"
end

land_polygons_dir = "#{node[:mapzen_odes][:setup][:basedir]}/data/#{node[:mapzen_odes][:coastlines][:land_polygons][:file]}".split('.zip').first
remote_file "#{node[:mapzen_odes][:setup][:basedir]}/data/#{node[:mapzen_odes][:coastlines][:land_polygons][:file]}" do
  owner       node[:mapzen_odes][:user][:id]
  mode        0644
  retries     10
  retry_delay 10
  backup      false
  source      node[:mapzen_odes][:coastlines][:land_polygons][:url]
  notifies    :run, 'execute[unzip land polygons]', :immediately
  not_if      { ::File.directory?(land_polygons_dir) }
end

execute 'unzip land polygons' do
  action  :nothing
  user    node[:mapzen_odes][:user][:id]
  cwd     "#{node[:mapzen_odes][:setup][:basedir]}/data"
  command "unzip -o #{node[:mapzen_odes][:coastlines][:land_polygons][:file]}"
end

# actual processing happens here
execute 'generate coastlines' do
  user    node[:mapzen_odes][:user][:id]
  cwd     node[:mapzen_odes][:setup][:basedir]
  timeout node[:mapzen_odes][:coastlines][:generate][:timeout]
  command "#{node[:mapzen_odes][:setup][:scriptsdir]}/coastlines.sh"
  only_if { node[:mapzen_odes][:json] }
end

# cron job to update coastline data
template "#{node[:mapzen_odes][:setup][:scriptsdir]}/update_polygons.sh" do
  owner   node[:mapzen_odes][:user][:id]
  mode    0755
  source  'update_polygons.sh.erb'
end

cron 'update polygons' do
  action  node[:mapzen_odes][:polygons_update][:cron] == true ? :create : :delete
  command "/usr/local/bin/lockrun --lockfile /tmp/.update_polygons.lock -- #{node[:mapzen_odes][:setup][:scriptsdir]}/update_polygons.sh >#{node[:mapzen_odes][:setup][:basedir]}/logs/update_polygons.log 2>&1"
  user    node[:mapzen_odes][:user][:id]
  home    "#{node[:mapzen_odes][:setup][:basedir]}/data"
  hour    '13'
  minute  '0'
  weekday '0'
end
