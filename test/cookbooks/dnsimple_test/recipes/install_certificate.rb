user 'www-data' do
  action :create
end

directory '/etc/apache2/ssl' do
  owner 'www-data'
  group 'www-data'
  recursive true
end

dnsimple_certificate 'dnsimple.xyz' do
  install_path '/etc/apache2/ssl'
  common_name 'www.dnsimple.xyz'
  domain node['dnsimple']['test_domain']
  access_token node['dnsimple']['access_token']
  base_url node['dnsimple']['base_url']
  mode '0755'
  owner 'web_admin'
  group 'web_admin'
end
