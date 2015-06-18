#
# Cookbook Name:: odes
# Recipe:: coastlines
#

execute 'wget water polygons' do
  user    node[:mapzen_odes][:user][:id]
  cwd     "#{node[:mapzen_odes][:setup][:basedir]}/data"
  command <<-EOH
    wget --quiet -O #{node[:coastlines][:water_polygons][:file]} \
      #{node[:coastlines][:water_polygons][:url]} &&
      unzip #{node[:coastlines][:water_polygons][:file]}
  EOH
  not_if  { ::File.exist?("#{node[:mapzen_odes][:setup][:basedir]}/#{node[:coastlines][:water_polygons][:file]}") }
  only_if { node[:mapzen_odes][:process][:coastlines] == true }
end

execute 'wget land polygons' do
  user    node[:mapzen_odes][:user][:id]
  cwd     "#{node[:mapzen_odes][:setup][:basedir]}/data"
  command <<-EOH
    wget --quiet -O #{node[:coastlines][:land_polygons][:file]} \
      #{node[:coastlines][:land_polygons][:url]} &&
      unzip #{node[:coastlines][:land_polygons][:file]}
  EOH
  not_if  { ::File.exist?("#{node[:mapzen_odes][:setup][:basedir]}/#{node[:coastlines][:land_polygons][:file]}") }
  only_if { node[:mapzen_odes][:process][:coastlines] == true }
end

execute 'generate coastlines' do
  user    node[:mapzen_odes][:user][:id]
  cwd     node[:mapzen_odes][:setup][:basedir]
  timeout node[:coastlines][:generate][:timeout]
  command <<-EOH
    #{node[:mapzen_odes][:setup][:scriptsdir]}/coastlines.sh \
      >#{node[:mapzen_odes][:setup][:basedir]}/logs/coastlines.log 2>&1
  EOH
  only_if { node[:mapzen_odes][:process][:coastlines] == true }
end
