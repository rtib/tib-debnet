# == Define: iface::bridge
#
# Resource to define a bridge interface configuration stanza within
# interfaces(5).
#
# == Parameters
#
# [*ifname*] => *(namevar)* - string
#   Name of the interface to be configured.
#
# [*method*] - string
#   Configuration method to be used.
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
# [*ports*] - array
#  Array of ports to be added to the bridge.
#
# [*stp*] - bool
#  Sets if bridge should implement spanning tree protocol.
#
# [*prio*] - int
#  Priority of the bridge for root selection within spanning tree.
#
# [*fwdelay*] - int
#  Sets the forward delay of the bridge in seconds.
#
# [*hello*] - int
#  Sets the bridge hello time in seconds.
#
# [*maxage*] - int
#  Maximum seconds of age of STP message.
#
# [*maxwait*] - int
#  Maximum seconds to wait for bridge interfaces to come up.
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
# [*tx_queue*] - int
#  Feature helper for setting tx queue on the interface.
#
# [*routes*] - hash
#  Feature helper for setting static routes via the interface.
#
# [*dns_nameserver*] - array
#  Feature helper to add a list of nameservers to be configures via resolvconf
#  while the interface is set up.
#
# [*dns_search*] - array
#  Feature helper to add a list of domain names as dns search via resolvconf
#  while the interface is set up.
#
# === Authors
#
# Tibor Repasi
#
# === Copyright
#
# Copyright 2016 Tibor Repasi
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
define debnet::iface::bridge(
  $method,
  $ifname = $title,
  $auto = true,
  $allows = [],
  $family = 'inet',
  $order = 0,
  $iface_d = undef,

  # bridge options
  $ports = [],
  $stp = false,
  $prio = undef,
  $fwdelay = undef,
  $hello = undef,
  $maxage = undef,
  $maxwait = undef,

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
  $routes = {},
  $dns_nameservers = undef,
  $dns_search = undef,
) {
  include debnet

  if !defined(Package[$debnet::params::bridge_utils_pkg]) {
    package { $debnet::params::bridge_utils_pkg:
      ensure => 'installed',
    }
  }

  if size($ports) > 0 {
    $brports = join($ports, ' ')
    debnet::iface { $ports:
      method   => 'manual',
      tx_queue => $tx_queue,
    }
  } else {
    $brports = 'none'
  }
  $bropts0 = {'bridge_ports' => $brports}
  if $hwaddress {
    $bropts1 = {'bridge_hw' => $hwaddress}
  } else {
    $bropts1 = {}
  }
  $bropts2 = {'bridge_stp' => $stp ? { true => 'on', default => 'off'} }
  if $stp {
    if $prio {
      validate_re($prio, '^\d+$')
      $bropts3 = { 'bridge_bridgeprio' => $prio}
    } else {
      $bropts3 = {}
    }
    if $fwdelay {
      validate_re($fwdelay, '^\d+$')
      $bropts4 = { 'bridge_fd' => $fwdelay }
    } else {
      $bropts4 = {}
    }
    if $hello {
      validate_re($hello, '^\d+$')
      $bropts5 = { 'bridge_hello' => $hello }
    } else {
      $bropts5 = {}
    }
    if $maxage {
      validate_re($maxage, '^\d+$')
      $bropts6 = { 'bridge_maxage' => $maxage }
    } else {
      $bropts6 = {}
    }
    if $maxwait {
      validate_re($maxwait, '^\d+$')
      $bropts7 = { 'bridge_maxwait' => $maxwait }
    } else {
      $bropts7 = {}
    }
  }
  debnet::iface { $ifname:
    method          => $method,
    auto            => $auto,
    allows          => $allows,
    family          => $family,
    order           => $order,
    iface_d         => $iface_d,
    metric          => $metric,
    hostname        => $hostname,
    leasetime       => $leasetime,
    vendor          => $vendor,
    client          => $client,
    address         => $address,
    netmask         => $netmask,
    broadcast       => $broadcast,
    gateway         => $gateway,
    pointopoint     => $pointopoint,
    mtu             => $mtu,
    scope           => $scope,
    pre_ups         => $pre_ups,
    ups             => $ups,
    downs           => $downs,
    post_downs      => $post_downs,
    aux_ops         => merge(
      $aux_ops,
      $bropts0,
      $bropts1,
      $bropts2,
      $bropts3,
      $bropts4,
      $bropts5,
      $bropts6,
      $bropts7),
    routes          => $routes,
    dns_nameservers => $dns_nameservers,
    dns_search      => $dns_search,
  }
}