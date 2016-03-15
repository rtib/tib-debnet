require 'spec_helper'

describe 'debnet::iface' do
  let(:title) { 'eth0' }
  let(:facts) {{
    :concat_basedir => '/var/lib/puppet/concat',
    :osfamily => 'Debian',
  }}

  context "Non-Debian system" do
    let(:facts) {{
      :osfamily => 'RedHat',
    }}
    it {
      expect { should raise_error(Puppet::Error) }
    }
  end

  context 'eth0 with address and mask' do
    let(:params) {{
      :method  => 'static',
      :address => '192.168.254.253',
      :netmask => '24',
    }}
    it {
      should contain_concat('/etc/network/interfaces').with({
        'owner'          => 'root',
        'group'          => 'root',
        'mode'           => '0644',
        'ensure_newline' => true,
        'order'          => 'numeric',
      })
      should contain_concat__fragment('/etc/network/interfaces').with({
        'target' => '/etc/network/interfaces',
        'order'  => '10',
      })
      should contain_concat__fragment('/etc/network/interfaces') \
        .with_content(/controlled by Puppet module trepasi-debnet/)
      should contain_concat__fragment('eth0_stanza').with({
        'target' => '/etc/network/interfaces',
      })
      should contain_concat__fragment('eth0_stanza') \
        .with_content(/^# interface eth0 configuration/)
      should contain_concat__fragment('eth0_stanza') \
        .with_content(/^iface eth0 inet static/)
    }
  end

end
