name             'mapzen_odes'
maintainer       'mapzen'
maintainer_email 'grant@mapzen.com'
license          'GPL v3'
description      'Installs/Configures odes'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.13.0'
source_url       'https://github.com/mapzen/chef-mapzen_odes' if respond_to?(:source_url)
issues_url       'https://github.com/mapzen/chef-mapzen_odes/issues' if respond_to?(:source_url)

recipe 'mapzen_odes', 'Builds metro extracts ode service'

%w(
  apt
  ark
  postgresql
  python
  user
).each do |dep|
  depends dep
end

%w(ubuntu).each do |os|
  supports os
end
