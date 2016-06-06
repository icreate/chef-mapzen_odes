#
# Cookbook Name:: mapzen_odes
# Recipe:: postgres
#

# note that if you're not using the local postgres installation, you'll need to manually
#   enable the postgis and hstore extensions in your database.
if node[:mapzen_odes][:postgres][:host] == 'localhost'
  package 'postgis'

  %w(
    postgresql::server
    postgresql::server_dev
    postgresql::contrib
    postgresql::postgis
  ).each do |r|
    include_recipe r
  end

  # override the default postgres template
  r = resources(template: "/etc/postgresql/#{node[:postgresql][:version]}/main/postgresql.conf")
  r.cookbook('odes')
  r.source('postgresql.conf.standard.erb')

  directory node[:postgresql][:data_directory] do
    action  :create
    owner   'postgres'
  end

  postgresql_user node[:mapzen_odes][:postgres][:user] do
    createdb  true
    login     true
    superuser true
    encrypted_password node[:mapzen_odes][:postgres][:password]
  end

  # drop then create the db. Ensure we're fresh on every run
  #   should we need to start over in the middle for some reason.
  postgresql_database node[:mapzen_odes][:postgres][:db] do
    action :drop
  end

  postgresql_database node[:mapzen_odes][:postgres][:db] do
    owner     node[:mapzen_odes][:postgres][:user]
    encoding  'utf8'
    template  'template0'
  end

  postgresql_extension 'postgis' do
    database node[:mapzen_odes][:postgres][:db]
  end

  postgresql_extension 'hstore' do
    database node[:mapzen_odes][:postgres][:db]
  end

  # force a restart up front
  service 'postgresql' do
    action :restart
  end
else
  package 'postgresql-client'
  package 'postgis'
end
