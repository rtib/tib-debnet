# == Define: support/wvdial
#
# Resource to define wvdial() configuration
#
# == Examples
#
# See the examples folder for usage examples of the wvdial function
#
# == Parameters
#
# [*device*] - string
#  Specify which device to use for this config.
#  Each channel will require a different device, e.g. voice on ACM0,
#  data on ACM1, etc
#
# [*baud*] - string
#
# [*username*] - string
# [*password*] - string
#
# [*init*] - array
#  will produce:
#    Init1 = ATZ
#    Init2 = ATQ0 V1 E1 S0=0 &C1 &D2 +FCLASS=0
#    Init3 = AT+CFUN=1
#    Init4 = AT+CGDCONT=1,"IP","INTERNETSTATIC", "1.2.3.4"
#
# [*autodns*] - (on|off)
#  Whether to add nameserver information to /etc/resolv.conf
#
# === Authors
#
# David Raison
#
# === Copyright
#
# Copyright 2016 David Raison
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
define debnet::support::wvdial(
  $device,
  $baud,
  $init = [],
  $username = undef,
  $password = undef,
  $autodns = 'off',
) {

  validate_string($device)
  validate_string($baud)
  validate_array($init)
  validate_re($autodns, '^on$|^off$')

  if $username {
    validate_string($username)
  }

  if $password {
    validate_string($password)
  }

  file { '/etc/wvdial.conf':
    ensure  => file,
    content => template('debnet/wvdial.conf.erb'),
  }
}
