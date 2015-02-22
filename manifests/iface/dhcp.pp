# == Define: iface::dhcp
#
# Resource to define an interface configuration stanza within interfaces(5).
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
# Copyright 2014 Tibor Repasi
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
define debnet::iface::dhcp (
  $ifname = $title,
  $auto = true,
  $allows = [],
  $family = 'inet',
  $order = 0,

  $metric = undef,
  $hwaddress = undef,
  $hostname = undef,
  $leasetime = undef,
  $vendor = undef,
  $client = undef,

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
  validate_string($ifname)
  validate_bool($auto)
  validate_array($allows)
  validate_re($family, '^inet$' )
  
  debnet::iface { $ifname :
    method     => 'dhcp',
    hostname   => $hwaddress,
    metric     => $metric,
    leasetime  => $leasetime,
    vendor     => $vendor,
    client     => $client,
    hwaddress  => $hwaddress,
    pre_ups    => $pre_ups,
    ups        => $ups,
    downs      => $downs,
    post_downs => $post_downs,
    aux_ops    => $aux_ops,
    tx_queue   => $tx_queue,
  }
}
