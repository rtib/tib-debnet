# debnet #

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does](#module-description)

##Overview

This module constructs the /etc/network/interfaces file on Debian based 
Linux distributions and enables an easy configuration of sophisticated
network setups.

##Module Description

This module lets you use many debnet::iface{} resourses for setting up
network interfaces.

##Setup

###Beginning with the module
To start with the debnet module the node definition must include the
module itself. Many nodes need at least a loopback interface which might
be:

```puppet
include debnet

debnet::iface { 'lo':
  method => 'loopback',
}
```

###Available configuration methods
The resource debnet::iface{} implements different configuration methods
also available for the interfaces(5) stanzas. Currently supported methods
are:
* loopback
* static
* dhcp

##Reference

###Classes

####Public classes

####Private classes
* `debnet::params`: Sets defaults for parameters.

###Defines

####debnet::iface

#####`title` - string
The name of the interface to be configured.

#####`auto` - bool
Sets the interface on automatic setup on startup. This is affected by 
`ifup -a` and `ifdown -a` commands.

#####`hotplug` - bool
Enables the interface to be handled as hotplug device. This feature and
auto is mutually exclusive. Declaring both features true will raise a
warning message.

####`family` - string
Currently, only inet family is supported. Support for `inet6` is comming
soon.

####`method` - string
Configuration method to be used. Currently supported methods are:
* static
* dhcp



