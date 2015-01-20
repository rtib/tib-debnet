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
    * [Bridge configuration](#bridge-config)
    * [Bonding configuration](#bond-config)
    * [Using Up and down command hooks](#updown-hooks)
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
To start with the debnet module the node can simply declare resources. Many
nodes need at least a loopback interface which might look like:

```puppet
debnet::iface::loopback { 'lo': }
```

###Available configuration methods
The resource debnet::iface{} implements different configuration methods
also available for the interfaces(5) stanzas. Currently supported methods
are:
* loopback
* static
* dhcp
* manual

###Configuring the loopback interface
Currently there is on a single way to create a configuration on the
loopback interface.

```puppet
debnet::iface::loopback { 'lo': }
```

Alternatively, you may use the generic resource debnet::iface as:
```puppet
debnet::iface { 'lo':
  method => 'loopback',
}
```

###Static IPv4 interface configuration
For a static IP configuration the attributes address and netmask are mandatory.
Attributes broadcast, gateway, pointopoint, hwaddress, mtu and scope are
optional.

```puppet
debnet::iface::static { 'eth0':
  address => '192.168.0.10',
  netmask => '24',
  gateway => '192.168.0.1',
}
```

The alternative configuration using generic resource is:
```puppet
debnet::iface { 'eth0':
  method  => 'static',
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

The alternative configuration using generic resource is:
```puppet
debnet::iface { 'eth0':
  method => 'dhcp',
}
```

###Bridge configuration
Configuring a software bridge is enabled by declaring a resource of type
debnet::iface::bridge. Mandatory attribute is the method of configuration of
the bridge interface. Depending on the method, the mandatory attributes
of the choosen method are also mandatory for the bridge resource. Optional
attributes are ports, stp, prio, fwdelay and hello.

An example for configuring a bridge is:

```puppet
debnet::iface::bridge { 'br0':
  ports  => ['eth1','eth2'],
  stp    => true,
  method => 'manual',
}
```

The alternative configuration using the debnet::iface resource is more
sophicticated here and needs more attention. First, it must be taken care that
the package bridge-utils is installed on the node. Second, the bridge interface
can be configured with debnet::iface by adding the bridge options through
auxiliary attribute hash.

```puppet
debnet::iface { 'br0':
  method  => 'manual',
  aux_ops => {
    'bridge_ports' => 'eth1 eth2',
    'bridge_stp'   => 'on',
  },
}
```

The debnet::iface::bridge resource is defining interfaces for many ports of the
bridge with manual configuration to inhibit multiple use of the same interface.

###Bonding configuration
The module allows to bond multiple interfaces together by configuring a linux
bonding device.

```puppet
debnet::iface::bond { 'bond0':
  ports => ['eth1', 'eth2'],
  method => 'manual',
}
```

Available attributes:
* ports - array of slave interfaces
* mode - string with bonding mode, supported modes are
** balance-rr
** active-backup
** balance\-xor
** broadcast
** 802.3ad
** balance-tlb
** balance-alb
* miimon - integer setting of mii monitor timing
* use_carrier - bool to enable carrier sense (if supported)
* updelay - integer setting the updelay timer
* downdelay - integer setting the downdelay timer

Such a configuration will create the interfaces(5) stanzas for many ports and
the bonding device. The array in argument ports must have at least one item,
and the first item will be configured as bond-primary.

###Using Up and down command hooks
Many debnet resources allow to add commands to the usual up/down hooks. The
attributes pre_ups, ups, downs and post_downs are available for many resources.
Each of which are typed as array and many elements will be added in order as
pre-up, up, down or post-down options, respectively. High care must be taken 
while using these attributes, since the module does not do any kind of checks.

```puppet
debnet::iface::dhcp { 'eth0':
  ups   => ['echo "eth0 is up"'],
  downs => ['echo "eth0 is going down"']
}
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
