require 'spec_helper'
require 'dnsimple'
require_relative '../../libraries/provider_dnsimple_record'
require_relative '../../libraries/resource_dnsimple_record'

describe Chef::Provider::DnsimpleRecord do
  before(:each) do
    @node = stub_node(platform: 'ubuntu', version: '14.04') do |node|
      node.default['dnsimple']['version'] = '1.2.3'
    end
    @events = Chef::EventDispatch::Dispatcher.new
    @run_context = Chef::RunContext.new(@node, {}, @events)
    @new_resource = Chef::Resource::DnsimpleRecord.new('record_name')
    @current_resource = Chef::Resource::DnsimpleRecord.new('record_name')
    @provider = Chef::Provider::DnsimpleRecord.new(@new_resource, @run_context)
    @provider.current_resource = @current_resource
  end

  describe '#create_record' do
    before(:each) do
      @new_resource.access_token('this_is_a_token')
      @provider.dnsimple_client = client
      @new_resource.record_name = dns_record[:name]
      @new_resource.type = dns_record[:type]
      @new_resource.content = dns_record[:content]
      @new_resource.domain = dns_record[:domain]
      allow(@provider).to receive(:dnsimple_gem_require).and_return(true)
    end

    let(:client) { instance_double(Dnsimple::Client, identity: identity, zones: zones) }
    let(:identity) { instance_double(Dnsimple::Client::Identity, whoami: response) }
    let(:response) { instance_double(Dnsimple::Response, data: data) }
    let(:data) { instance_double(Dnsimple::Struct::Whoami, account: account) }
    let(:account) { instance_double(Dnsimple::Struct::Account, id: 1) }
    let(:zones) { instance_double(Dnsimple::Client::ZonesService, create_record: zone_record) }
    let(:zone_record) { instance_double(Dnsimple::Struct::ZoneRecord) }
    let(:dns_record) do
      {
        name: 'test_record',
        domain: 'example.com',
        type: 'A',
        content: '1.2.3.4',
        ttl: 60
      }
    end

    it 'returns record object if record name matches' do
      expect(@provider.create_record.name).to eq('example_record')
    end
  end
end
