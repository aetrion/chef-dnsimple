#
# Cookbook Name:: dnsimple
# Recipe:: default
#
# Copyright 2014-2016 Aetrion, LLC
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

case node['platform_family']
when 'debian'
  include_recipe 'apt::default'

  package 'zlib1g-dev' do
    action :install
  end.run_action(:install)
end

include_recipe 'build-essential'

chef_gem 'fog-dnsimple' do
  version node['dnsimple']['fog_version']
  compile_time true if Chef::Resource::ChefGem.instance_methods(false).include?(:compile_time)
  action :install
end

require 'fog/dnsimple'
