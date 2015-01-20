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
define debnet::iface::loopback (
  $ifname = $title,
  $auto = true,
  $allows = [],
  $family = 'inet',
  $order = 0,
) {
  validate_re($ifname, '^lo$')
  validate_bool($auto)
  validate_array($allows)
  validate_re($family, '^inet$' )
  debnet::iface { $ifname:
    method => 'loopback',
    auto   => $auto,
    allows => $allows,
    family => $family,
  }
}
