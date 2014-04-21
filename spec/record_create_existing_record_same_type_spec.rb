require 'spec_helper'
require 'fog/dnsimple'

describe 'dnsimple_test::create_record_existing_record_same_type' do
  include_context 'dnsimple'

  context 'with an existing record with the same name and ttl same type' do
    it 'deletes existing record and creates new record' do
      create_record_to_update
      chef_run

      dnsimple_resource = chef_run
        .find_resource('dnsimple_record', 'custom record name')
      expect(dnsimple_resource.updated_by_last_action?).to be_true

      record = dnsimple_zone.records.find { |r| r.name == 'existing' }
      expect(record.value).to eq '1.1.1.1'
    end
  end
end
