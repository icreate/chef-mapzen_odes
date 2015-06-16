name             'mapzen_odes'
maintainer       'mapzen'
maintainer_email 'grant@mapzen.com'
license          'GPL v3'
description      'Installs/Configures odes'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.0'

recipe 'mapzen_odes', 'Builds metro extracts ode service'

%w(
  apt
  ark
  osm2pgsql
  postgresql
  python
  user
).each do |dep|
  depends dep
end

%w(ubuntu).each do |os|
  supports os
end
