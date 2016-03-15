# == Define: iface::static
#
# Resource to define simple interface with static configuration stanza within
# interfaces(5).
#
# == Parameters
#
# [*ifname*] => *(namevar)* - string
#   Name of the interface to be configured.
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
# [*metric*] - int
#  Routing metric for routes added resolved on this interface.
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
# [*hwaddress*] - string
#   The MAC address of the interface. This value is validated as standard
#   IEEE MAC address of 6 bytes, written hexadecimal, delimited with
#   colons (:) or dashes (-).
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
define debnet::iface::static (
  $address,
  $netmask,

  $ifname = $title,
  $auto = true,
  $allows = [],
  $family = 'inet',
  $order = 0,
  $iface_d = undef,

  $broadcast = undef,
  $metric = undef,
  $gateway = undef,
  $pointopoint = undef,
  $hwaddress = undef,
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

  validate_string($ifname)
  validate_bool($auto)
  validate_array($allows)
  validate_re($family, '^inet$' )

  debnet::iface { $ifname:
    method          => 'static',
    auto            => $auto,
    allows          => $allows,
    family          => $family,
    order           => $order,
    iface_d         => $iface_d,
    address         => $address,
    netmask         => $netmask,
    broadcast       => $broadcast,
    metric          => $metric,
    gateway         => $gateway,
    pointopoint     => $pointopoint,
    hwaddress       => $hwaddress,
    mtu             => $mtu,
    scope           => $scope,
    pre_ups         => $pre_ups,
    ups             => $ups,
    downs           => $downs,
    post_downs      => $post_downs,
    aux_ops         => $aux_ops,
    tx_queue        => $tx_queue,
    routes          => $routes,
    dns_nameservers => $dns_nameservers,
    dns_search      => $dns_search,
  }
}
