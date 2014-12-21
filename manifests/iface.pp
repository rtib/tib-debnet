define debnet::iface (
  $ifname = $title,
  $auto = true,
  $allows = [],
  $family = 'inet',
  $method,
  $order = 0,

  # options for multiple methods  
  $metric = undef,
  $hwaddress = undef,

  # options for method dhcp
  $hostname = undef,
  $leasetime = undef,
  $vendor = undef,
  $client = undef,
  
  # options for method static
  $address = undef,
  $netmask = undef,
  $broadcast = undef,
  $gateway = undef,
  $pointopoint = undef,
  $mtu = undef,
  $scope = undef,
  
) {
  validate_string($ifname)
  validate_bool($auto)
  validate_array($allows)
  validate_re($family, '^inet$' )
  validate_re($method, '^loopback$|^dhcp$|^static$')
  
  case $method {
    'loopback' : { 
      concat::fragment { "lo_stanza":
        target  => $debnet::params::interfaces_file,
        content => template('debnet/loopback.erb'),
        order   => 10 + $order,
      }
    }
    
    'dhcp' : {
      package { 'isc-dhcp-client': ensure => 'installed', }
      if $hostname { validate_re($hostname, '^(?![0-9]+$)(?!-)[a-zA-Z0-9-]{,63}(?<!-)$') }
      if $metric { validate_re($metric, '^\d+$') }
      if $leasetime { validate_re($leasetime, '^\d+$') }
      if $vendor { validate_string($vendor) }
      if $client { validate_string($client) }
      if $hwaddress { validate_re($hwaddress, '^([0-9A-F]{2}[:-]){5}([0-9A-F]{2})$') }
      
      concat::fragment { "${ifname}_stanza":
        target  => $debnet::params::interfaces_file,
        content => template('debnet/iface_header.erb', 'debnet/inet_dhcp.erb'),
        order   => 20 + $order,
      }
    }
    
    'static' : {
		  validate_re($address, '^(:?[0-9]{1,3}\.){3}[0-9]{1,3}$')
		  validate_re($netmask, '^([0-9]{1,3}\.){3}[0-9]{1,3}$|^[0-9]{1,2}$')
		  if $broadcast { validate_re($broadcast, '^([0-9]{1,3}\.){3}[0-9]{1,3}$|^[+-]$') }
		  if $metric { validate_re($metric, '^\d+$') }
		  if $gateway { validate_re($gateway, '(:?[0-9]{1,3}\.){3}[0-9]{1,3}$') }
		  if $pointopoint { validate_re($pointopoint, '(:?[0-9]{1,3}\.){3}[0-9]{1,3}$') }
		  if $hwaddress { validate_re($hwaddress, '^([0-9A-F]{2}[:-]){5}([0-9A-F]{2})$') }
		  if $mtu { validate_re($mtu, '^\d+$') }
		  if $scope { validate_re($scope, '^global$|^link$|^host$') }

      concat::fragment { "${ifname}_stanza":
        target  => $debnet::params::interfaces_file,
        content => template('debnet/iface_header.erb', 'debnet/inet_static.erb'),
        order   => 20 + $order,
      }
    }

  }
}
