def whyrun_supported?
	true
end

action :create do
	if @current_resource.exists
		Chef::Log.info "#{ @new_resource } already exists - nothing to do."
	else
		converge_by("Create #{ @new_resource }") do
			create_remoteapp
		end
	end
end

action :delete do
	if @current_resource.exists
		converge_by("Delete #{ @new_resource }") do
			delete_remoteapp
		end
	else
		Chef::Log.info "#{ @current_resource } doesn't exist - can't delete."
	end
end

def load_current_resource
	@current_resource = Chef::Resource::WindowsRdsRemoteapp.new(@new_resource.alias)
	@current_resource.alias(@new_resource.alias)
	@current_resource.displayname(@new_resource.displayname)
	@current_resource.path(@new_resource.path)

	if remoteapp_exists?(@current_resource.alias)
		@current_resource.exists = true
	end
end

def create_remoteapp
	remote_directory "#{ENV['SYSTEMROOT']}\\sysnative\\WindowsPowerShell\\v1.0\\Modules\\RDSRemoteApp" do
		# This PowerShell module from http://archive.msdn.microsoft.com/PSRDSRemoteApp is very helpful for our needs here
		source "RDSRemoteApp"
		cookbook "windows_rds"		
	end

	powershell "Creating RemoteApp #{new_resource.alias}" do
		code <<-EOH
		Import-Module RDSRemoteApp
		New-RDSRemoteApp -Alias "#{new_resource.alias}" -Applicationpath "#{new_resource.path}" -Displayname "#{new_resource.displayname}"
		EOH
	end
end

def delete_remoteapp
	remote_directory "#{ENV['SYSTEMROOT']}\\sysnative\\WindowsPowerShell\\v1.0\\Modules\\RDSRemoteApp" do
		# This PowerShell module from http://archive.msdn.microsoft.com/PSRDSRemoteApp is very helpful for our needs here
		source "RDSRemoteApp"
		cookbook "windows_rds"
	end

	powershell "Deleting RemoteApp #{new_resource.alias}" do
		code <<-EOH
		Import-Module RDSRemoteApp
		Remove-RDSRemoteApp -Alias "#{new_resource.alias}"
		EOH
	end
end

def remoteapp_exists?(name)
	Registry.key_exists?('HKLM\Software\Microsoft\Windows NT\CurrentVersion\Terminal Server\TSAppAllowList\Applications\\' + name)
end
