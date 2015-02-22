# == Define: iface
#
# Resource to define an interface configuration stanza within interfaces(5).
#
# == Parameters
#
# [*ifname*] => *(namevar)* - string
#   Name of the interface to be configured.
#
# [*method*] - string
#   Configuration method to be used. Supported methods are:
#   * loopback
#   * dhcp
#   * static
#   * manual
#
# [*auto*] - bool
#   Sets the interface on automatic setup on startup. This is affected by
#   ifup -a and ifdown -a commands.
#
# [*allows*] - array
#   Adds an allow- entry to the interface stanza.
#
# [*family*] - string
#   Address family. Currently, only inet family is supported. Support for
#   inet6 is comming soon.
#
# [*order*] - int
#   Order of the entry to be created in /etc/network/interfaces. Innate
#   odering is preset with default value of 10 for loopback and 20 for dhcp
#   and static stanzas. The order attribute of the resource is added to the
#   default value.
#
# [*hwaddress*] - string
#   The MAC address of the interface. This value is validated as standard
#   IEEE MAC address of 6 bytes, written hexadecimal, delimited with
#   colons (:) or dashes (-).
#
# [*hostname*] - string
#   The hostname to be submitted with dhcp requests.
#
# [*leasetime*] - int
#   The requested leasetime of dhcp leases.
#
# [*vendor*] - string
#   The vendor id to be submitted with dhcp requests.
#
# [*client*] - string
#  The client id to be submitted with dhcp requests.
#
# [*metric*] - int
#  Routing metric for routes added resolved on this interface.
#
# [*address*] - string
#  IP address formatted as dotted-quad for IPv4.
#
# [*netmask*] - string
#  Netmask as dotted-quad or CIDR prefix length.
#
# [*broadcast*] - string
#  Broadcast address as dotted-quad or + or -.
#
# [*gateway*] - string
#  Default route to be brought up with this interface.
#
# [*pointopoint*] - stirng
#  Address of the ppp endpoint as dotted-quad.
#
# [*mtu*] - int
#  Size of the maximum transportable unit over this interface.
#
# [*scope*] - string
#  Scope of address validity. Values allowed are global, link or host.
#
# [*pre_ups*] - array
#  Array of commands to be run prior to bringing this interface up.
#
# [*ups*] - array
#  Array of commands to be run after bringing this interface up.
#  
# [*downs*] - array
#  Array of commands to be run prior to bringing this interface down.
#
# [*post_downs*] - array
#  Array of commands to be run after bringing this interface down.
#
# [*aux_ops*] - hash
#  Hash of key-value pairs with auxiliary options for this interface.
#  To be used by other debnet types only.
#
# === Authors
#
# Tibor Repasi
#
# === Copyright
#
# Copyright 2015 Tibor Repasi
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
define debnet::iface (
  $method,
  $ifname = $title,
  $auto = true,
  $allows = [],
  $family = 'inet',
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

  # up and down commands
  $pre_ups = [],
  $ups = [],
  $downs = [],
  $post_downs = [],

  # auxiliary options
  $aux_ops = {},

  # feature-helpers
  $tx_queue = undef,
) {
  include debnet
  
  validate_string($ifname)
  validate_bool($auto)
  validate_array($allows)
  validate_re($family, '^inet$' )
  validate_re($method, '^loopback$|^dhcp$|^static$|^manual$')
  validate_hash($aux_ops)
  validate_array($pre_ups)
  validate_array($ups)
  validate_array($downs)
  validate_array($post_downs)
  if $tx_queue {
    validate_re($tx_queue, '^\d+$')
  }
  
  case $method {
    'loopback' : {
      concat::fragment { 'lo_stanza':
        target  => $debnet::params::interfaces_file,
        content => template('debnet/loopback.erb'),
        order   => 10 + $order,
      }
    }
    
    'dhcp' : {
      if !defined(Package['isc-dhcp-client']) {
        package { 'isc-dhcp-client': ensure => 'installed', }
      }
      if $hostname { validate_re($hostname,
        '^(?![0-9]+$)(?!-)[a-zA-Z0-9-]{,63}(?<!-)$') }
      if $metric { validate_re($metric, '^\d+$') }
      if $leasetime { validate_re($leasetime, '^\d+$') }
      if $vendor { validate_string($vendor) }
      if $client { validate_string($client) }
      if $hwaddress { validate_re($hwaddress,
        '^([0-9A-F]{2}[:-]){5}([0-9A-F]{2})$') }
      
      concat::fragment { "${ifname}_stanza":
        target  => $debnet::params::interfaces_file,
        content => template(
          'debnet/iface_header.erb',
          'debnet/inet_dhcp.erb',
          'debnet/iface_aux.erb'),
        order   => 20 + $order,
      }
    }
    
    'static' : {
      validate_re($address, '^(:?[0-9]{1,3}\.){3}[0-9]{1,3}$')
      validate_re($netmask, '^([0-9]{1,3}\.){3}[0-9]{1,3}$|^[0-9]{1,2}$')
      if $broadcast {
        validate_re($broadcast, '^([0-9]{1,3}\.){3}[0-9]{1,3}$|^[+-]$')
      }
      if $metric { validate_re($metric, '^\d+$') }
      if $gateway { validate_re($gateway, '(:?[0-9]{1,3}\.){3}[0-9]{1,3}$') }
      if $pointopoint {
        validate_re($pointopoint, '(:?[0-9]{1,3}\.){3}[0-9]{1,3}$')
      }
      if $hwaddress {
        validate_re($hwaddress, '^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$')
      }
      if $mtu { validate_re($mtu, '^\d+$') }
      if $scope { validate_re($scope, '^global$|^link$|^host$') }

      concat::fragment { "${ifname}_stanza":
        target  => $debnet::params::interfaces_file,
        content => template(
          'debnet/iface_header.erb',
          'debnet/inet_static.erb',
          'debnet/iface_aux.erb'),
        order   => 20 + $order,
      }
    }
    'manual' : {
      concat::fragment { "${ifname}_stanza":
        target  => $debnet::params::interfaces_file,
        content => template(
          'debnet/iface_header.erb',
          'debnet/inet_manual.erb',
          'debnet/iface_aux.erb'),
        order   => 20 + $order,
      }
    }
    default: {
      err('unrecognized method')
    }
  }
}
