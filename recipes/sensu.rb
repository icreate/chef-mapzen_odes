#
# Cookbook Name:: mapzen_odes
# Recipe:: sensu
#
# Copyright 2013, Mapzen
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'mapzen_sensu_clients::default'

template '/usr/local/bin/check-planet-age.rb' do
  owner   'root'
  group   'root'
  mode    0755
  source  'sensu-check-planet-age.rb.erb'
end

sensu_check 'check_planet_age' do
  command     '/usr/local/bin/check-planet-age.rb'
  standalone  true
  handlers    node[:mapzen_sensu_clients][:handlers_array]
  interval    3600
  additional(
    occurrences: 1,
    refresh: 3600,
    event_code: 995,
    event_code_url: 'https://github.com/mapzen/wiki/wiki/Event-Codes#995',
    opsworks_stack_url: 'https://console.aws.amazon.com/opsworks/home?region=us-east-1#/stack/a100d5bf-6309-4304-8f1e-b57ed85769c9/stack'
  )
end
