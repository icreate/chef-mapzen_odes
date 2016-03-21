#
# Cookbook Name:: odes
# Attributes:: default
#

# pass json directly
default[:mapzen_odes][:json]                                      = nil
default[:mapzen_odes][:upload_data]                               = false

default[:mapzen_odes][:upload][:aws_sdk_version]                  = '2.2.26'
default[:mapzen_odes][:awscli][:version]                          = '1.10.14'
default[:mapzen_odes][:upload][:s3bucket]                         = 'mapzen.odes'

# setup
default[:mapzen_odes][:setup][:basedir]                           = '/mnt/odes'
default[:mapzen_odes][:setup][:scriptsdir]                        = '/opt/odes-scripts'

# user
default[:mapzen_odes][:user][:id]                                 = 'odes'
default[:mapzen_odes][:user][:shell]                              = '/bin/bash'
default[:mapzen_odes][:user][:manage_home]                        = false
default[:mapzen_odes][:user][:create_group]                       = true
default[:mapzen_odes][:user][:ssh_keygen]                         = false

# imposm
default[:mapzen_odes][:imposm][:version]                          = '0.2'
default[:mapzen_odes][:imposm][:installdir]                       = '/usr/local'
default[:mapzen_odes][:imposm][:url]                              = 'http://imposm.org/static/rel/imposm3-0.1dev-20150515-593f252-linux-x86-64.tar.gz'

# postgres
default[:mapzen_odes][:postgres][:host]                           = 'localhost' # setting to something other than localhost will result in the local postgres installation being skipped
default[:mapzen_odes][:postgres][:db]                             = 'osm'
default[:mapzen_odes][:postgres][:user]                           = 'osm'
default[:mapzen_odes][:postgres][:password]                       = 'password'
default[:postgresql][:data_directory]                             = '/mnt/postgres/data'
default[:postgresql][:autovacuum]                                 = 'off'
default[:postgresql][:work_mem]                                   = '64MB'
default[:postgresql][:temp_buffers]                               = '128MB'
default[:postgresql][:shared_buffers]                             = '3GB'
default[:postgresql][:maintenance_work_mem]                       = '512MB'
default[:postgresql][:checkpoint_segments]                        = '100'
default[:postgresql][:max_connections]                            = '200'

# planet
default[:mapzen_odes][:planet][:timeout]                          = 3600
default[:mapzen_odes][:planet][:url]                              = 'planet.us-east-1.mapzen.com/planet-latest.osm.pbf'
default[:mapzen_odes][:planet][:file]                             = node[:mapzen_odes][:planet][:url].split('/').last

# extracts
default[:mapzen_odes][:osmconvert][:timeout]                      = 172_800
default[:mapzen_odes][:osmconvert][:jobs]                         = node[:cpu][:total]

# shapes: note that the number of jobs below reflects close to the limit of what the
#   limit of a single postgres instance can handle in terms of max connections.
#   Not recommended to change.
default[:mapzen_odes][:shapes][:imposm_jobs]                      = 12
default[:mapzen_odes][:shapes][:osm2pgsql_jobs]                   = 8
default[:mapzen_odes][:shapes][:osm2pgsql_timeout]                = 172_800

# coastlines
default[:mapzen_odes][:coastlines][:jobs]                         = node[:cpu][:total]
default[:mapzen_odes][:coastlines][:generate][:timeout]           = 7_200
default[:mapzen_odes][:coastlines][:water_polygons][:url]         = 'http://data.openstreetmapdata.com/water-polygons-split-4326.zip'
default[:mapzen_odes][:coastlines][:land_polygons][:url]          = 'http://data.openstreetmapdata.com/land-polygons-split-4326.zip'
default[:mapzen_odes][:coastlines][:water_polygons][:file]        = node[:mapzen_odes][:coastlines][:water_polygons][:url].split('/').last
default[:mapzen_odes][:coastlines][:land_polygons][:file]         = node[:mapzen_odes][:coastlines][:land_polygons][:url].split('/').last
