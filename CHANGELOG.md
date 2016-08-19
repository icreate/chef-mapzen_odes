mapzen_odes changelog
=====================

0.12.9
------
* try and drop all tables

0.12.8
------
* install osm2pgsql from package as we're on Ubuntu 16.04 now

0.12.7
------
* use hash-memory flag when converting shapes

0.12.6
------
* osmupdate planet file on setup

0.12.5
------
* no lockfile when updating planet or polygons

0.12.4
------
* make geojson optional again, cuz it's nice

0.12.3
------
* geojson processing is no longer optional

0.12.2
------
* fix bug in geojson processing

0.12.1
------
* provide some randomization of cron initiation times

0.12.0
------
* update coastline data weekly via cron rather than checking data via chef on every instantiation

0.11.1
------
* retry coastline downloads for up to 10 minutes

0.11.0
------
* use `remote_file` resource to pull polygons in order to keep them updated over time

0.10.2
------
* aws-sdk install should be a chef-gem to support upload

0.10.1
------
* add aws-sdk gem

0.10.0
------
* chef 12

0.9.0
-----
* change file outputs to replace . with _

0.8.1
-----
* simplify shapes and coastlines template code

0.8.0
-----
* parallel coastlines

0.7.0
-----
* total revamp

0.6.3
-----
* use 4236 everywhere

0.6.2
-----
* use 4326 for imposm
* bump imposm version

0.6.1
-----
* set -e on planet update script
* don't need to force creation of an extract if we're only asked to build coastlines

0.6.0
-----
* split out pbf and xml extracts to avoid having to process both if we don't want them

0.5.0
-----
* allow only imposm or osm2pgsql shp

0.4.1
-----
* add some logic around setting opts

0.4.0
-----
* make geojson generation optional

0.3.0
-----
* update user
* change mount dir
* create data dir
