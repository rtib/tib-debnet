require 'spec_helper'

describe 'debnet' do
  let(:facts) {{
    :concat_basedir => '/var/lib/puppet/concat',
    :osfamily => 'Debian',
  }}
  
  it {
    should contain_class('Debnet')
    should contain_class('Debnet::Params')
    should contain_package('iproute').with({
      'ensure' => 'installed',
    })
  }
end
