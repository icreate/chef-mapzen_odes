mapzen_odes
===========

What does it do?
----------------
Downloads the latest planet in pbf format.
Produces, via osmconvert, a number of metro extracts in both pbf and bz2 formats.
Produces shape files in both imposm and osm2pgsql formats.

Projections
-----------
GeoJSON is generated via ogr2ogr and output in CRS:84 (e.g. EPSG:4326) projection.

Imposm shapfiles are generated in EPSG:4326.

What hardware do I need?
------------------------
An m4.4xlarge is a good starting point, anything bigger will make things faster.
About 300gb of storage for the planet file and all the extracts you plan to generate,
plus Postgres (if you run it locally... you can use something like RDS as well).

Supported Platforms
-------------------
Tested and supported on the following platforms:

* Ubuntu 14.04LTS

Requirements
------------
* Chef >= 11.4

Usage
-----

Run the recipe `mapzen_odes::default`, and pass custom json in the `node[:mapzen_odes][:json]`
attribute containing a list of cities and bbox's. The city name is arbitrary but will be used
to name output files, so ensure they're unique in a given run. You can then pass boolean values to
any of the process attributes to include (or not) the output they handle.

Expected json blob sample:

```
  {
    'mapzen_odes': {
      'upload_data': true,
      'json': {
        'cities': {
          'some_city': {
            'bbox': {
              'top': 'bbox_n',
              'left': 'bbox_w',
              'bottom': 'bbox_s',
              'right': 'bbox_e'
            },
            'process': {
              'imposm_shapes': true,
              'xml_extracts': true,
              'coastlines': true,
              'imposm_geojson': true
            }
          }
        }
      }
    }
  }

