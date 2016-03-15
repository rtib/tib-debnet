# == Define: iface::loopback
#
# Resource to define an loopback interface stanza within interfaces(5).
#
# == Parameters
#
# [*ifname*] => *(namevar)* - string
#  Must conventionally always be 'lo'.
#
# [*auto*] - bool
#   Sets the interface on automatic setup on startup. This is affected by
#   ifup -a and ifdown -a commands.
#
# [*allows*] - array
#   Adds an allow- entry to the interface stanza.
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
define debnet::iface::loopback (
  $ifname = $title,
  $auto = true,
  $allows = [],
  $family = 'inet',
  $order = 0,
  $iface_d = undef,

  # up and down commands
  $pre_ups = [],
  $ups = [],
  $downs = [],
  $post_downs = [],

  # auxiliary options
  $aux_ops = {},
) {
  include debnet

  validate_re($ifname, '^lo$')
  validate_bool($auto)
  validate_array($allows)
  validate_re($family, '^inet$' )
  debnet::iface { $ifname:
    method     => 'loopback',
    auto       => $auto,
    allows     => $allows,
    family     => $family,
    order      => $order,
    iface_d    => $iface_d,
    pre_ups    => $pre_ups,
    ups        => $ups,
    downs      => $downs,
    post_downs => $post_downs,
    aux_ops    => $aux_ops,
  }
}
