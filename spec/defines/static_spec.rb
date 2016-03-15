require 'spec_helper'

describe 'debnet::iface::static' do
  let(:title) { 'eth0' }
  let(:facts) {{
    :concat_basedir => '/var/lib/puppet/concat',
    :osfamily => 'Debian',
  }}

  context 'eth0 with address and mask' do
    let(:params) {{
      :address  => '192.168.254.253',
      :netmask  => '24',
    }}
    it {
      should contain_debnet__iface('eth0').with({
        'method'  => 'static',
        'family'  => 'inet',
        'address' => '192.168.254.253',
        'netmask' => '24',
      })
    }
  end

  context 'eth0 with address and mask on different location' do
    let(:params) {{
      :address  => '192.168.254.253',
      :netmask  => '24',
      :iface_d  => 'test',
    }}
    it {
      should contain_debnet__iface('eth0').with({
        'method'  => 'static',
        'family'  => 'inet',
        'iface_d' => 'test',
        'address' => '192.168.254.253',
        'netmask' => '24',
      })
    }
  end
end
