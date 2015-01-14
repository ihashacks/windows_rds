# windows_rds cookbook

# Requirements

# Usage

# Attributes

* `node[:windows_rds][:cert][:cn]`
* `node[:windows_rds][:cert][:location]`
* `node[:windows_rds][:cert][:password]`
* `node[:windows_rds][:remoteapp][:hostname]`
* `node[:windows_rds][:rds_users]`

# Recipes

default
-------
Installs RDS server roles and sets RDS SSL certificate and RemoteApp hostname, if those attributes are configured.

roles
-----
Installs RDS server roles.

# Resources/Providers

`windows_rds_remoteapp`
-----------------------

### Actions

- :create: *Default action*
- :delete:

### Attribute Parameters

- alias
- displayname
- path
- userassignment

# Author

Author:: Adam Mielke, (C) Regents of the University of Minnesota (<adam@umn.edu>)
