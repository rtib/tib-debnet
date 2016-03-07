# == Class: debnet
#
# Initial class of module.
#
# === Parameters
#
# none
#
# === Variables
#
# none
#
# === Examples
#
# include debnet
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
class debnet {
  include debnet::params

  if $::osfamily != 'Debian' {
    fail('This module supports Debian based Linux distributions only.')
  }

  package { $debnet::params::iproute_pkg:
    ensure => 'installed',
  }
}
