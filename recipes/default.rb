#
# Cookbook Name:: windows_rds
# Recipe:: default
#
# Copyright (C) 2013 Adam Mielke, (C) Regents of the University of Minnesota
# 

# Ensure the RDS session host roles are installed
include_recipe "#{cookbook_name}::roles"

# Import SSL certificate to the local store if the attribute for it has been set
if node[:windows_rds][:cert][:location]
	include_recipe "#{cookbook_name}::import_certificate"
end	

# Set the RDS TLS certificate if the attribute for it has been set
if node[:windows_rds][:cert][:cn]
	powershell "Set RDS certificate" do
	  code <<-EOH
	  $modules = Get-Module -ListAvailable | Select-Object Name
	  $DesiredCert = (Get-ChildItem cert:/localmachine/my | Where-Object {$_.Subject -match "^CN=#{node[:windows_rds][:cert][:cn]}"}).Thumbprint
	  Import-Module RemoteDesktopServices
	  $CurrentCert = (Get-Item RDS:/RDSConfiguration/Connections/RDP-Tcp/SecuritySettings/SSLCertificateSHA1Hash).CurrentValue
	  if ($CurrentCert -ne $DesiredCert) {
	    Set-Item RDS:/RDSConfiguration/Connections/RDP-Tcp/SecuritySettings/SSLCertificateSHA1Hash $DesiredCert
	  }
	  EOH
	end
end

if node[:windows_rds][:remoteapp][:hostname]
	powershell "Set RemoteApp Hostname" do
		# Don't set this if the DeploymentRDPSettings key already is set with this value.
		not_if { reg_value = Registry.get_value('HKLM\Software\Microsoft\Windows NT\CurrentVersion\Terminal Server\TSAppAllowList','DeploymentRDPSettings')
			      !reg_value.nil? and reg_value.match("full address:s:#{node[:windows_rds][:remoteapp][:hostname]}") }
		code <<-EOH
		Import-Module RemoteDesktopServices
		Set-Item RDS:/RemoteApp/ServerName #{node[:windows_rds][:remoteapp][:hostname]}
		EOH
	end
end