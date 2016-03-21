mapzen_odes
===========

Expected json blob (`node[:mapzen_odes][:json]`) to enable processing of a bbox:

```
  {
    'mapzen_odes': {
      'upload_data': true,
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
