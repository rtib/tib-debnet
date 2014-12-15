# Class: debnet
#
# This module manages debnet
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class debnet inherits debnet::params {
  concat { "$interfaces_file" :
    owner          => 'root',
    group          => 'root',
    mode           => '0644',
    ensure_newline => true,
  }
  
  concat::fragment { "interfaces_header":
    target  => $interfaces_file,
    content => template('debnet/header.erb'),
    order   => 01,
  }
}
