require 'spec_helper'

describe 'debnet::iface::dhcp' do
  let(:title) { 'eth0' }
  let(:facts) {{
    :concat_basedir => '/var/lib/puppet/concat',
    :osfamily => 'Debian',
  }}

  context 'eth0 standard' do
    it {
      should contain_package('isc-dhcp-client')
      should contain_debnet__iface('eth0').with({
        'method' => 'dhcp',
        'family' => 'inet',
      })
    }
  end

  context 'eth0 with params' do
    let(:params) {{
      :hostname  => 'test',
      :metric    => '20',
      :leasetime => '1234',
      :vendor    => 'vendor',
      :client    => 'client',
      :hwaddress => '11:22:33:44:55:66',
    }}
    it {
      should contain_package('isc-dhcp-client')
      should contain_debnet__iface('eth0').with({
        'method'    => 'dhcp',
        'family'    => 'inet',
        'hostname'  => 'test',
        'metric'    => '20',
        'leasetime' => '1234',
        'vendor'    => 'vendor',
        'client'    => 'client',
        'hwaddress' => '11:22:33:44:55:66',
      })
    }
  end

  context 'eth0 with bad hostname' do
    let(:params) {{
      :hostname  => 'test.example.org',
    }}
    it {
      expect { should raise_error(Puppet::Error) }
    }
  end

  context 'eth0 with bad hwaddress' do
    let(:params) {{
      :hwaddress => '11:22:33:44:55:66:xx',
    }}
    it {
      expect { should raise_error(Puppet::Error) }
    }
  end
end
