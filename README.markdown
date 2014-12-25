# debnet #

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does](#module-description)
3. [Setup - Basic usage of module debnet](#setup)
    * [Beginning with the module](#beginning)
    * [Available configuration methods](#config-available)
    * [Configuring the loopback interface](#loopback-config)
    * [Static IPv4 configuration](#static-config)
    * [DHCP configuration](#dhcp-config)
4. [Reference](#reference)

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

###Configuring the loopback interface
Currently there is on a single way to create a configuration on the
loopback interface.

```puppet
debnet::iface::loopback { 'lo': }
```

###Static IPv4 configuration
For a static IP configuration the attributes address and netmask are
mandatory. Attributes broadcast, gateway, pointopoint, hwaddress, mtu and
scope are optional.

```puppet
debnet::iface::static { 'eth0':
  address => '192.168.0.10',
  netmask => '24',
  gateway => '192.168.0.1',
}
```

###DHCP configuration
Configuring an interface by dhcp is enabled through method set to 
according. Optional attributes hostname, metric, leasetime, vendor, client
and hwaddress may be set.

```puppet
debnet::iface::dhcp { 'eth0': }
```
##Reference

###Classes

####Public classes

####Private classes
* `debnet::params`: Sets defaults for parameters.

###Defines

####debnet::iface::loopback
Creates an interfaces(5) stanza to configure the loopback device.

#####`title` - string
Must be 'lo'.

####debnet::iface::dhcp
Creates an interfaces(5) stanza to configure a simple device with dhcp.

#####`title` - string
Name of the interface to be configured

#####`metric` - int
Routing metric for routes comming with this interface.

#####`hostname` - string
The hostname to be submitted with dhcp requests.

#####`leasetime` - int
The requested leasetime of dhcp leases.

#####`vendor` - string
The vendor id to be submitted with dhcp requests.

#####`client` - string
The client id to be submitted with dhcp requests.

####debnet::iface::static
Creates an interfaces(5) stanza to configure a simple device with static
settings.

#####`title` - string
The name of the interface to be configured.

#####`hwaddress` - string
The MAC address of the interface. This value is validated as standard IEEE
MAC address of 6 bytes, written hexadecimal, delimited with colons (:) or
dashes (-).

#####`metric` - int
Routing metric for routes added resolved on this interface.

#####`address` - string
IP address formatted as dotted-quad for IPv4.

#####`netmask` - string
Netmask as dotted-quad or CIDR prefix length.

#####`broadcast` - string
Broadcast address as dotted-quad or + or -.

#####`gateway` - string
Default route to be brought up with this interface.

#####`pointopoint` - string
Address of the ppp endpoint as dotted-quad.

#####`mtu` - int
Size of the maximum transportable unit over this interface.

#####`scope` - string
Scope of address validity. Values allowed are global, link or host.

####debnet::iface

#####`title` - string
The name of the interface to be configured.

#####`auto` - bool
Sets the interface on automatic setup on startup. This is affected by 
`ifup -a` and `ifdown -a` commands.

#####`allows` - array
Adds an `allow-` entry to the interface stanza.

#####`family` - string
Currently, only inet family is supported. Support for `inet6` is comming
soon.

#####`method` - string
Configuration method to be used. Currently supported methods are:
* static
* dhcp

#####`order` - int
Order of the entry to be created in `/etc/network/interfaces`. Innate
odering is preset with default value of 10 for loopback and 20 for
dhcp and static stanzas. The `order` attribute of the resource is added to
the default value.

#####`hwaddress` - string
The MAC address of the interface. This value is validated as standard IEEE
MAC address of 6 bytes, written hexadecimal, delimited with colons (:) or
dashes (-).

#####`hostname` - string
The hostname to be submitted with dhcp requests.

#####`leasetime` - int
The requested leasetime of dhcp leases.

#####`vendor` - string
The vendor id to be submitted with dhcp requests.

#####`client` - string
The client id to be submitted with dhcp requests.

#####`metric` - int
Routing metric for routes added resolved on this interface.

#####`address` - string
IP address formatted as dotted-quad for IPv4.

#####`netmask` - string
Netmask as dotted-quad or CIDR prefix length.

#####`broadcast` - string
Broadcast address as dotted-quad or + or -.

#####`gateway` - string
Default route to be brought up with this interface.

#####`pointopoint` - string
Address of the ppp endpoint as dotted-quad.

#####`mtu` - int
Size of the maximum transportable unit over this interface.

#####`scope` - string
Scope of address validity. Values allowed are global, link or host.

#####`pre_ups` - array
Array of commands to be added as pre-up.

#####`ups` - array
Array of commands to be added as up.

#####`downs` - array
Array of commands to be added as down.

#####`post_downs` - array
Array of commands to be added as post-down.

#####`aux_ops` - hash
Auxiliary options. For future internal use only.
