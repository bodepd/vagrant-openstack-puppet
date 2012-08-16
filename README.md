This project can be used to build out openstack environments in 3 kinds of ways:
- multi-node openstack environment using puppet apply
- multi-node openstack environment using razor and puppet open source
- multi-node openstack environment using razor and PE

## openstack environment using razor and PE

1. install PE.

  You should get PE version 2.5.3 for Ubuntu 64 bit from our website and place it in the files directory of this project
  (you can also run the rake task openstack_demo:fetch_pe to download the installer payload, dont do this though, seriously)

2. set the environment variable

    export USE_PE=true

3. install and configure PE + Razor

    rake deploy:razor

This script does the following:

- fetches the project git://github.com/branan/razor-puppet-puppetdb-demo.git
- uses it to install and configure a functional server running PE, puppetdb, razor
- fetches the openstack puppet modules and writes them into the masters directory
- configures the razor master to 

## openstack with puppet and razor

    rake deploy:razor
