# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.network :hostonly, "33.33.33.30"

  config.vm.share_folder "v-data", "/data", ".", :owner=> 'vagrant', :group=>'www-data'
  config.vm.share_folder "v-root", "/vagrant", "vagrant", :owner=> 'vagrant', :group=>'www-data'

  config.vm.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  config.vm.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-data", "1"]
  
  config.vm.provision :shell, :path => "vagrant/provision.sh"
  
  config.vm.customize ["modifyvm", :id, "--memory", 1024]

end
