#
# Cookbook Name:: windows_rds
# Recipe:: import_certificate
#
# Copyright (C) 2013 Adam Mielke, (C) Regents of the University of Minnesota
# 

cert_thumbprint = Digest::SHA1.hexdigest(OpenSSL::PKCS12.new(IO.binread(node[:windows_rds][:cert_location]),node[:windows_rds][:cert_password]).certificate.to_der)

execute "Import certificate" do
  command "certutil -p \"#{node[:windows_rds][:cert_password]}\" -importpfx \"#{node[:windows_rds][:cert_location]}\""
  not_if { Registry.key_exists?("HKLM\\SOFTWARE\\Microsoft\\SystemCertificates\\my\\Certificates\\#{cert_thumbprint}") }
  action :run
end
