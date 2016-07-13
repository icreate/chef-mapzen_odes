#
# Cookbook Name:: mapzen_odes
# Recipe:: coastlines
#

remote_file "#{node[:mapzen_odes][:setup][:basedir]}/data/#{node[:mapzen_odes][:coastlines][:water_polygons][:file]}" do
  owner       node[:mapzen_odes][:user][:id]
  mode        0644
  retries     2
  retry_delay 60
  backup      false
  source      node[:mapzen_odes][:coastlines][:water_polygons][:url]
  notifies    :run, 'execute[unzip water polygons]', :immediately
end

execute 'unzip water polygons' do
  action  :nothing
  user    node[:mapzen_odes][:user][:id]
  cwd     "#{node[:mapzen_odes][:setup][:basedir]}/data"
  command <<-EOF
    unzip -o #{node[:mapzen_odes][:coastlines][:water_polygons][:file]}
  EOF
end 

remote_file "#{node[:mapzen_odes][:setup][:basedir]}/data/#{node[:mapzen_odes][:coastlines][:land_polygons][:file]}" do
  owner       node[:mapzen_odes][:user][:id]
  mode        0644
  retries     2
  retry_delay 60
  backup      false
  source      node[:mapzen_odes][:coastlines][:water_polygons][:url]
  notifies    :run, 'execute[unzip land polygons]', :immediately
end

execute 'unzip land polygons' do
  action  :nothing
  user    node[:mapzen_odes][:user][:id]
  cwd     "#{node[:mapzen_odes][:setup][:basedir]}/data"
  command <<-EOF
    unzip -o #{node[:mapzen_odes][:coastlines][:land_polygons][:file]}
  EOF
end 

execute 'generate coastlines' do
  user    node[:mapzen_odes][:user][:id]
  cwd     node[:mapzen_odes][:setup][:basedir]
  timeout node[:mapzen_odes][:coastlines][:generate][:timeout]
  command "#{node[:mapzen_odes][:setup][:scriptsdir]}/coastlines.sh"
  only_if { node[:mapzen_odes][:json] }
end
