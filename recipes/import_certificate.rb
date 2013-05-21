#
# Cookbook Name:: windows_rds
# Recipe:: import_certificate
#
# Copyright (C) 2013 Adam Mielke, (C) Regents of the University of Minnesota
# 

Chef::Recipe.send(:include, Windows::Helper)
certutil = locate_sysnative_cmd("certutil.exe")

cert_location = win_friendly_path(node[:windows_rds][:cert][:location])

execute "Import certificate" do
  command "#{certutil} -p \"#{node[:windows_rds][:cert][:password]}\" -importpfx \"#{cert_location}\""
  not_if { %x[#{certutil} -store my] =~ /CN=#{node[:windows_rds][:cert][:cn]},/ }
  action :run
end
