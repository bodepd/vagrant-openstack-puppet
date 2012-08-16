#
# This environment is intended to demonstrate how a use could bootstrap an openstack
# environment from bare matal in a totally automated fashion.
#

class String
  def to_bool
    return true if self == true || self =~ (/(true|t|yes|y|1)$/i)
    return false if self == false || self.blank? || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end

Vagrant::Config.run do |config|

  if num_instances_str = ENV['OPENSTACK_COMPUTE_NODES']
    num_instances = num_instances_str.to_i + 1
  else
    num_instances = 2
  end

  # This assumes the master has one additional NIC that is host-only
  master_info = `VBoxManage showvminfo master.puppetlabs.vm`
  master_info.lines.each { |l| $master_nic_info = l if l =~ /NIC 2/ }
  unless $master_nic_info =~ /Host-only Interface '(\w+)'/
    puts "Warning:Could not determine the Host-only network adapter, this may result in vm failures"
  end
  host_network = $1

  if ENV['OPENSTACK_GUI_MODE']
    gui_mode = ENV['OPENSTACK_GUI_MODE'].to_bool
  else
    gui_mode = true
  end

  (0...num_instances).each do |i|
    config.vm.define "agent#{i}".intern do |agent|
      if i == 0 # host 0 is a special snowflake
        agent.vm.customize ["modifyvm", :id, "--memory", 512]
      else
        agent.vm.customize ["modifyvm", :id, "--memory", 2048]
      end

      # create a second NIC and enable promiscuous networking
      agent.vm.customize ["modifyvm", :id, "--hostonlyadapter1", host_network]
      agent.vm.customize ["modifyvm", :id, "--nicpromisc1", "allow-all"]
      agent.vm.customize ["modifyvm", :id, "--nic2", "hostonly"]
      agent.vm.customize ["modifyvm", :id, "--hostonlyadapter2", host_network]
      agent.vm.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      agent.vm.customize ["modifyvm", :id, "--nic3", "nat"]

      agent.vm.boot_mode = 'gui' if gui_mode
      agent.vm.box = "agent#{i}"
      agent.vm.box_url = 'https://github.com/downloads/benburkert/bootstrap-razor/pxe-blank.box'
      agent.vm.customize ["modifyvm", :id, "--name", "agent#{i}.puppetlabs.lan"]
      agent.vm.customize ["modifyvm", :id, "--macaddress1", 'auto']
      agent.ssh.port = 2222
    end
  end
end
