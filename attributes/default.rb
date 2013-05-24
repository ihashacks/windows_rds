# If you want to select a TLS certificate to secure the RDP connection,
# set this to the CN of a certificate in the local certificate store that
# you wish to use.
default[:windows_rds][:cert][:cn] = nil

# If you want to use a different RemoteApp hostname than the node's name (i.e. your nodes are in a farm), set this
default[:windows_rds][:remoteapp][:hostname] = nil

# If using the import_certificate recipe, set the two attributes below:
default[:windows_rds][:cert][:location] = nil # A local PKCS12 certificate that the node can read
default[:windows_rds][:cert][:password] = nil # The password required to decrypt the PKCS12 file

# If this attribute is set, the default recipe will manage the "Remote Desktop Users" group. Set it to an array of users and/or groups.
# e.g. node.set[:windows_rds][:rds_users] = [ "MYDOMAIN\\my remote desktop users group", "MYDOMAIN\\some user", "somelocaluser" ]
default[:windows_rds][:rds_users] = nil