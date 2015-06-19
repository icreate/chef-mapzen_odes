#
# Cookbook Name:: mapzen_odes
# Recipe:: _set_options
#

# if we're told to process these things, pbf extracts needs to be true.
# only coastlines don't need a pbf_extract.
if
  node[:mapzen_odes][:process][:xml_extracts]       == true ||
  node[:mapzen_odes][:process][:imposm_shapes]      == true ||
  node[:mapzen_odes][:process][:osm2pgsql_shapes]   == true ||
  node[:mapzen_odes][:process][:osm2pgsql_geojson]  == true ||
  node[:mapzen_odes][:process][:imposm_geojson]     == true

  node.set[:mapzen_odes][:process][:pbf_extracts] = true
end

# if we're told to process geojson, relevant shapes need to be true
if node[:mapzen_odes][:process][:osm2pgsql_geojson]  == true
  node.set[:mapzen_odes][:process][:osm2pgsql_shapes] = true
end

if node[:mapzen_odes][:process][:imposm_geojson]  == true
  node.set[:mapzen_odes][:process][:imposm_shapes] = true
end
