# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  config.vm.define :web do |web_config|
	web_config.vm.box = "precise64"
  	web_config.vm.box_url = "http://files.vagrantup.com/precise64.box"

	web_config.vm.share_folder "projects", "/projects", "../../../Dropbox/projects"
  	web_config.vm.share_folder "sites", "/sites", "sites"

  	web_config.vm.network :hostonly, "192.168.10.10"

	web_config.vm.provision :puppet do |puppet|
	    puppet.manifests_path = "web-puppet/manifests"
	    puppet.manifest_file  = "default.pp"
	    puppet.module_path = "web-puppet/modules"
	    #puppet.options = "--verbose --debug"
	    #puppet.options = "--verbose"
	end
  end

  config.vm.define :web do |db_config|
	db_config.vm.box = "precise64"
  	db_config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  	db_config.vm.network :hostonly, "192.168.10.11"
	db_config.vm.provision :puppet do |puppet|
	    puppet.manifests_path = "db-puppet/manifests"
	    puppet.manifest_file  = "default.pp"
	    puppet.module_path = "db-puppet/modules"
	    #puppet.options = "--verbose --debug"
	    #puppet.options = "--verbose"
	end
  end
  
end
