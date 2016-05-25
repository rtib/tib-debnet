require 'spec_helper'

describe 'debnet::iface::loopback' do
  let(:title) { 'lo' }
  let(:facts) {{
    :concat_basedir => '/var/lib/puppet/concat',
    :osfamily => 'Debian',
  }}
  
  it {
    should contain_debnet__iface('lo').with({
      'method' => 'loopback',
      'family' => 'inet',
    })
    should contain_concat__fragment('lo_stanza')
  }
end
