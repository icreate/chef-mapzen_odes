#
# Cookbook Name:: mapzen_odes
# Recipe:: _set_options
#

unless node[:mapzen_odes][:json].nil?
  require 'json'
  json = JSON.parse(node[:mapzen_odes][:json])

  json['cities'].each do |city, val|
    # set defaults
    node.default[:mapzen_odes][city][:pbf_extracts] = false
    node.default[:mapzen_odes][city][:xml_extracts] = false
    node.default[:mapzen_odes][city][:coastlines] = false
    node.default[:mapzen_odes][city][:imposm_shapes] = false
    node.default[:mapzen_odes][city][:imposm_geojson] = false
    node.default[:mapzen_odes][city][:osm2pgsql_shapes] = false
    node.default[:mapzen_odes][city][:osm2pgsql_geojson] = false

    # get opts passed in the json blob
    if val['process']
      val['process'].each do |opt, v|
        if v == true
          log "Setting node attribute: node[:mapzen_odes][:#{city}][:#{opt}] = true"
          node.set[:mapzen_odes][city][opt] = true
        end
      end
    end

    # if we're told to process these things, pbf extracts needs to be true.
    # only coastlines ([:mapzen_odes][:city][:coastlines]) don't need a pbf_extract.
    if node[:mapzen_odes][city][:xml_extracts] == true ||
       node[:mapzen_odes][city][:imposm_shapes] == true ||
       node[:mapzen_odes][city][:imposm_geojson] == true ||
       node[:mapzen_odes][city][:osm2pgsql_shapes] == true ||
       node[:mapzen_odes][city][:osm2pgsql_geojson] == true

      node.set[:mapzen_odes][city][:pbf_extracts] = true
    end

    # if we're told to process geojson, relevant shapes need to be true
    if node[:mapzen_odes][city][:osm2pgsql_geojson] == true
      node.set[:mapzen_odes][city][:osm2pgsql_shapes] = true
    end

    if node[:mapzen_odes][city][:imposm_geojson] == true
      node.set[:mapzen_odes][city][:imposm_shapes] = true
    end
  end
end
