actions :create, :delete
default_action :create

attribute :alias, :kind_of => String, :name_attribute => true, :required => true
attribute :displayname, :kind_of => String
attribute :path, :kind_of => String
attribute :userassignment, :kind_of => [String, Array]

attr_accessor :exists
