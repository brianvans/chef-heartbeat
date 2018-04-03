name             'elastic-heartbeat'
maintainer       'Virender Khatri'
maintainer_email 'vir.khatri@gmail.com'
license          'Apache 2.0'
description      'Installs/Configures elastic-heartbeat'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
source_url 'https://github.com/vkhatri/chef-heartbeat' if respond_to?(:source_url)
issues_url 'https://github.com/vkhatri/chef-heartbeat/issues' if respond_to?(:issues_url)

depends 'apt'
depends 'elastic_beats_repo'
depends 'yum'
depends 'yum-plugin-versionlock', '>= 0.1.2'

%w(ubuntu debian centos amazon redhat fedora).each do |os|
  supports os
end
