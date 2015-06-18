# if we're told to process anything, extracts needs to be true
if
  node[:mapzen_odes][:process][:imposm_shapes]      == true ||
  node[:mapzen_odes][:process][:osm2pgsql_shapes]   == true ||
  node[:mapzen_odes][:process][:coastlines]         == true ||
  node[:mapzen_odes][:process][:osm2pgsql_geojson]  == true ||
  node[:mapzen_odes][:process][:imposm_geojson]     == true

  node.set[:mapzen_odes][:process][:extracts] = true
end

# if we're told to process geojson, shapes and extracts need to be true
if node[:mapzen_odes][:process][:osm2pgsql_geojson]  == true
  node.set[:mapzen_odes][:process][:extracts]         = true
  node.set[:mapzen_odes][:process][:osm2pgsql_shapes] = true
end

if node[:mapzen_odes][:process][:imposm_geojson]  == true
  node.set[:mapzen_odes][:process][:extracts]      = true
  node.set[:mapzen_odes][:process][:imposm_shapes] = true
end
