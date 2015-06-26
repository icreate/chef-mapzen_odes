mapzen_odes changelog
=====================

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
