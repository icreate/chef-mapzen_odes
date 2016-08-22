#
# Cookbook Name:: mapzen_odes
# Recipe:: default
#

%w(
  apt::default
  mapzen_odes::_set_options
  mapzen_odes::postgres
  mapzen_odes::user
  mapzen_odes::setup
  mapzen_odes::planet
  mapzen_odes::sensu
  mapzen_odes::extracts
  mapzen_odes::shapes
  mapzen_odes::coastlines
  mapzen_odes::upload
).each do |r|
  include_recipe r
end
