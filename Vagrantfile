#
# This environment is intended to demonstrate how a use could bootstrap an openstack
# environment from bare matal in a totally automated fashion.
#
Vagrant::Config.run do |config|

  config.vm.box     = 'precise64'
  config.vm.box_url = 'http://files.vagrantup.com/precise64.box'

  # build out a puppet master yo!!
  config.vm.define :controller do |box_config|
    box_config.vm.host_name = 'controller.openstack.vm'

    box_config.vm.customize ["modifyvm", :id, "--memory", 1024]
    box_config.vm.customize ["modifyvm", :id, "--name", 'controller.openstack.vm']
    box_config.vm.boot_mode = 'gui'
    box_config.vm.network :hostonly, '172.16.0.3', :adapter => 2

    # this is to configure a host entry for communicating to the puppet master
    box_config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "hosts.pp"
      puppet.module_path    = 'razor-puppet-puppetdb-demo/modules'
    end

    box_config.vm.provision :puppet_server, :options => '--test --pluginsync' do | puppet|
      puppet.puppet_server = 'puppet'
      # always create a new certificate!
      puppet.puppet_node   = "openstack-controller-#{Time.now.strftime('%Y%m%d%m%s')}"
    end
  end

  config.vm.define :openstack_compute_1 do |box_config|
    box_config.vm.box       = 'precise64'
    box_config.vm.boot_mode = 'gui'
    box_config.vm.host_name = 'openstack-compute-1.openstack.vm'
    box_config.vm.customize ["modifyvm", :id, "--name", 'openstack-compute-1.openstack.vm']
    box_config.vm.customize ["modifyvm", :id, "--memory", 2048]
    box_config.vm.network :hostonly, '172.16.0.4', :adapter => 2
    box_config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "hosts.pp"
      puppet.module_path    = 'razor-puppet-puppetdb-demo/modules'
    end
    box_config.vm.provision :puppet_server, :options => '--test --pluginsync' do | puppet|
      puppet.puppet_server = 'puppet'
      puppet.puppet_node   = "openstack-compute-1-#{Time.now.strftime('%Y%m%d%m%s')}"
    end
  end

  config.vm.define :openstack_compute_2 do |box_config|
    box_config.vm.box       = 'precise64'
    box_config.vm.boot_mode = 'gui'
    box_config.vm.host_name = 'openstack-compute-2.openstack.vm'
    box_config.vm.customize ["modifyvm", :id, "--name", 'openstack-compute-2.openstack.vm']
    box_config.vm.customize ["modifyvm", :id, "--memory", 2048]
    box_config.vm.network :hostonly, '172.16.0.4', :adapter => 2
    box_config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "hosts.pp"
      puppet.module_path    = 'razor-puppet-puppetdb-demo/modules'
    end
    box_config.vm.provision :puppet_server, :options => '--test --pluginsync' do | puppet|
      puppet.puppet_server = 'puppet'
      puppet.puppet_node   = "openstack-compute-2-#{Time.now.strftime('%Y%m%d%m%s')}"
    end
  end

end
