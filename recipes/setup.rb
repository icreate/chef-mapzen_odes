#
# Cookbook Name:: mapzen_odes
# Recipe:: setup
#

include_recipe 'osm2pgsql::default'

%w(
  build-essential
  osmctools
  gdal-bin
  parallel
  pbzip2
  zip
).each do |p|
  package p
end

# imposm
ark 'imposm3' do
  owner         'root'
  url           node[:mapzen_odes][:imposm][:url]
  version       node[:mapzen_odes][:imposm][:version]
  prefix_root   node[:mapzen_odes][:imposm][:installdir]
  has_binaries  ['imposm3']
end

# scripts basedir
directory node[:mapzen_odes][:setup][:scriptsdir] do
  owner node[:mapzen_odes][:user][:id]
end

# cities
file "#{node[:mapzen_odes][:setup][:scriptsdir]}/cities.json" do
  owner     node[:mapzen_odes][:user][:id]
  content   node[:mapzen_odes][:json]
  only_if   { node[:mapzen_odes][:json] }
end

# scripts
%w(extracts.sh shapes.sh coastlines.sh).each do |t|
  template "#{node[:mapzen_odes][:setup][:scriptsdir]}/#{t}" do
    owner   node[:mapzen_odes][:user][:id]
    source  "#{t}.erb"
    mode    0755
  end
end

%w(osm2pgsql.style merge-geojson.py mapping.json).each do |f|
  cookbook_file "#{node[:mapzen_odes][:setup][:scriptsdir]}/#{f}" do
    owner   node[:mapzen_odes][:user][:id]
    source  f
    mode    0644
  end
end

%w(ex data logs shp coast).each do |d|
  directory "#{node[:mapzen_odes][:setup][:basedir]}/#{d}" do
    owner node[:mapzen_odes][:user][:id]
  end
end
