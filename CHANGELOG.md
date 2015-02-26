##2015-02-26 - Release 1.2.0

###Summary
Introduction of feature helpers. Configurable bridge parameters extended.

###Features
- feature helper tx_queue added for setting tx queue length of an interface
- added attributes maxage and maxwait to bridge

##2015-02-05 - Release 1.1.1

###Summary
Documentation bugfixes.

###Features

###Bugfixes
- requirements corrected
- README links fixed

##2015-02-04 - Release 1.1.0

###Summary
Operating system support tested. Up and down hooks now available for many resources.

###Features
- support for Debian 6 and Ubuntu 12.04 added to metadata.json
- added support for up/down hooks to resources bond, bridge, dhcp, loopback and static

##2015-01-20 - Release 1.0.1

###Summary
Bugfix.

###Changes
- Validation of bonding attributes fixed.

##2015-01-20 - Release 1.0.0

###Summary
Added support for bonding and removed the need of including the module.

###Changes
- including the module is not necessary anymore

###Features
- support for bonding devices

##2014-12-27 - Release 0.3.1

###Summary
Minor refactoring, documentation and metadata improvements.

####Fixes
- Metadata fixes to improve quality measures.
- Some lint warnings with bridge.pp fixed.
- Documentation fixed.

##2014-12-27 - Release 0.3.0

###Summary

New feature for configuring bridge interfaces.