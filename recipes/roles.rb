#
# Cookbook Name:: windows_rds
# Recipe:: roles
#
# Copyright (C) 2013 Adam Mielke, (C) Regents of the University of Minnesota
# 

# Install the following roles:
# AppServer - Remote Desktop Session Host
# AppServer-UI - Remote Desktop Session Host Configuration Tools

Chef::Recipe.send(:include, Windows::Helper)
dism = locate_sysnative_cmd("dism.exe")

windows_feature "AppServer"
windows_feature "AppServer-UI"

ruby_block "reboot" do
	block do
		node.save # Save the current node state. This is especially important if this is the first time the node has ever run chef.
		system("shutdown /r /t 60 /c \"Installing Role: Remote Desktop Session Host\"")
		raise "Reboot required to install Remote Desktop Session Host role"
	end
	only_if do
		cmd = Mixlib::ShellOut.new("#{dism} /online /Get-Features", {:returns => [0,42,127]}).run_command
    	cmd.stderr.empty? && (cmd.stdout =~  /^Feature Name : AppServer.*$\n^State : Enable Pending.?$/i)
	end
end