#
# Cookbook Name:: dnsimple
# Library:: dnsimple
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

begin
  require "fog/dnsimple"
  Excon.defaults[:ssl_verify_peer] = true
rescue LoadError
  Chef::Log.warn("Missing gem 'fog'")
end

module DNSimple
  module Connection
    def dnsimple
      if new_resource.password
        Chef::Log.warn('[DEPRECATED] Using username and password authentication will be removed in a future release.
                       See the README for examples of using the token based API.')
      end

      @@dnsimple ||= Fog::DNS.new( :provider => "DNSimple",
                                   :dnsimple_domain => new_resource.domain,
                                   :dnsimple_email => new_resource.username,
                                   :dnsimple_password => new_resource.password,
                                   :dnsimple_token => new_resource.token )
    end
  end
end
