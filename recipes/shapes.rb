#
# Cookbook Name:: mapzen_odes
# Recipe:: shapes
#

execute 'create shapes' do
  user      node[:mapzen_odes][:user][:id]
  cwd       node[:mapzen_odes][:setup][:basedir]
  command   "#{node[:mapzen_odes][:setup][:scriptsdir]}/shapes.sh"
  timeout   node[:mapzen_odes][:shapes][:osm2pgsql_timeout]
end
