#
# Cookbook Name:: odes
# Recipe:: _set_options
#

# if we're told to process anything (other than coastlines), pbf extracts needs to be true.
# xml extracts are the only entirely optional thing, as all formats are
#   built off of pbf extracts.
if
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
