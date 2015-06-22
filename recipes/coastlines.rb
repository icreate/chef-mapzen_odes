#
# Cookbook Name:: mapzen_odes
# Recipe:: coastlines
#

execute 'wget water polygons' do
  user    node[:mapzen_odes][:user][:id]
  cwd     "#{node[:mapzen_odes][:setup][:basedir]}/data"
  command <<-EOH
    wget --quiet -O #{node[:mapzen_odes][:coastlines][:water_polygons][:file]} \
      #{node[:mapzen_odes][:coastlines][:water_polygons][:url]} &&
      unzip #{node[:mapzen_odes][:coastlines][:water_polygons][:file]}
  EOH
  not_if  { ::File.exist?("#{node[:mapzen_odes][:setup][:basedir]}/data/#{node[:mapzen_odes][:coastlines][:water_polygons][:file]}") }
end

execute 'wget land polygons' do
  user    node[:mapzen_odes][:user][:id]
  cwd     "#{node[:mapzen_odes][:setup][:basedir]}/data"
  command <<-EOH
    wget --quiet -O #{node[:mapzen_odes][:coastlines][:land_polygons][:file]} \
      #{node[:mapzen_odes][:coastlines][:land_polygons][:url]} &&
      unzip #{node[:mapzen_odes][:coastlines][:land_polygons][:file]}
  EOH
  not_if  { ::File.exist?("#{node[:mapzen_odes][:setup][:basedir]}/data/#{node[:mapzen_odes][:coastlines][:land_polygons][:file]}") }
end

execute 'generate coastlines' do
  user    node[:mapzen_odes][:user][:id]
  cwd     node[:mapzen_odes][:setup][:basedir]
  timeout node[:mapzen_odes][:coastlines][:generate][:timeout]
  command "#{node[:mapzen_odes][:setup][:scriptsdir]}/coastlines.sh"
  only_if { node[:mapzen_odes][:json] }
end
