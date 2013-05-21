# If you want to select a TLS certificate to secure the RDP connection,
# set this to the CN of a certificate in the local certificate store that
# you wish to use.
default[:windows_rds][:cert][:cn] = nil

# If you want to use a different RemoteApp hostname than the node's name (i.e. your nodes are in a farm), set this
default[:windows_rds][:remoteapp][:hostname] = nil

# If using the import_certificate recipe, set the two attributes below:
default[:windows_rds][:cert][:location] = nil # A local PKCS12 certificate that the node can read
default[:windows_rds][:cert][:password] = nil # The password required to decrypt the PKCS12 file
