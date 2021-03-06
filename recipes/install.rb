#
# Cookbook Name:: elastic-heartbeat
# Recipe:: install
#
# Copyright 2017, Virender Khatri
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

version_string = node['platform_family'] == 'rhel' ? "#{node['heartbeat']['version']}-#{node['heartbeat']['release']}" : node['heartbeat']['version']

case node['platform_family']
when 'debian'
  package 'apt-transport-https'

  # apt repository configuration
  apt_repository 'beats' do
    uri node['heartbeat']['apt']['uri']
    components node['heartbeat']['apt']['components']
    key node['heartbeat']['apt']['key']
    distribution node['heartbeat']['apt']['distribution']
    action node['heartbeat']['apt']['action']
  end

  unless node['heartbeat']['ignore_version'] # ~FC023
    apt_preference 'heartbeat' do
      pin          "version #{node['heartbeat']['version']}"
      pin_priority '700'
    end
  end

when 'rhel'
  # yum repository configuration
  yum_repository 'beats' do
    description node['heartbeat']['yum']['description']
    baseurl node['heartbeat']['yum']['baseurl']
    gpgcheck node['heartbeat']['yum']['gpgcheck']
    gpgkey node['heartbeat']['yum']['gpgkey']
    enabled node['heartbeat']['yum']['enabled']
    metadata_expire node['heartbeat']['yum']['metadata_expire']
    action node['heartbeat']['yum']['action']
  end

  unless node['heartbeat']['ignore_version'] # ~FC023
    yum_version_lock 'heartbeat' do
      version node['heartbeat']['version']
      release node['heartbeat']['release']
      action :update
    end
  end
end

package 'heartbeat' do # ~FC009
  version version_string unless node['heartbeat']['ignore_version']
  options node['heartbeat']['apt']['options'] if node['heartbeat']['apt']['options'] && node['platform_family'] == 'debian'
  notifies :restart, 'service[heartbeat]' if node['heartbeat']['notify_restart'] && !node['heartbeat']['disable_service']
  flush_cache(:before => true) if node['platform_family'] == 'rhel'
  allow_downgrade true if node['platform_family'] == 'rhel'
end
