# == Class: params
#
# Parameter settings.
#
# === Parameters
#
# none
#
# === Variables
#
# none
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
class debnet::params {
  $interfaces_file = '/etc/network/interfaces'
  $interfaces_dir = '/etc/network/interfaces.d'
  $iproute_pkg = 'iproute2'
  $wvdial_pkg = 'wvdial'
  $dhclient_pkg = 'isc-dhcp-client'
  $bridge_utils_pkg = 'bridge-utils'
  $ifenslave_pkg = 'ifenslave-2.6'
}
