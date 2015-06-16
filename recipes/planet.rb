#
# Cookbook Name:: odes
# Recipe:: planet
#

# override tempfile location so the planet download
#   temp file goes somewhere with enough space
ENV['TMP'] = node[:mapzen_odes][:setup][:basedir]

# fail if someone tries to pull something other than
#   a pbf data file
fail if node[:mapzen_odes][:planet][:file] !~ /\.pbf$/

remote_file "#{node[:mapzen_odes][:setup][:basedir]}/#{node[:mapzen_odes][:planet][:file]}.md5" do
  action    :create_if_missing
  backup    false
  source    "#{node[:mapzen_odes][:planet][:url]}.md5"
  mode      0644
  notifies  :run, 'execute[download planet]',   :immediately
  notifies  :run, 'ruby_block[verify md5]',     :immediately
  notifies  :run, 'execute[osmconvert planet]', :immediately
end

execute 'download planet' do
  action  :nothing
  user    node[:mapzen_odes][:user][:id]
  command <<-EOH
    wget --quiet \
      -O #{node[:mapzen_odes][:setup][:basedir]}/#{node[:mapzen_odes][:planet][:file]} \
      #{node[:mapzen_odes][:planet][:url]}
  EOH
  timeout node[:mapzen_odes][:planet][:timeout]
end

ruby_block 'verify md5' do
  action :nothing
  block do
    require 'digest'

    planet_md5  = Digest::MD5.file("#{node[:mapzen_odes][:setup][:basedir]}/#{node[:mapzen_odes][:planet][:file]}").hexdigest
    md5         = File.read("#{node[:mapzen_odes][:setup][:basedir]}/#{node[:mapzen_odes][:planet][:file]}.md5").split(' ').first

    if planet_md5 != md5
      Chef::Log.info('Failure: the md5 of the planet we downloaded does not appear to be correct. Aborting.')
      abort
    end
  end
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
