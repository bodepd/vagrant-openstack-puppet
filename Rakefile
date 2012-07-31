require 'yaml'

repo_file = 'other_repos.yaml'

namespace :openstack_demo do

  desc 'install the puppet master with razor, dhcp, and puppetdb'
  task :install_master do

    # install razor-puppet-puppetdb-demo.git
    puts `git clone git://github.com/stephenrjohnson/razor-puppet-puppetdb-demo.git`

    Dir.chdir('razor-puppet-puppetdb-demo/') do

      # install all module dependencies
      puts `librarian-puppet install`
      # bring up a master
      puts `vagrant up master`

    end

  end

  desc 'clone all required modules'
  task :setup do
    require 'fileutils'
    repo_hash = YAML.load_file(File.join(File.dirname(__FILE__), repo_file))
    repos = (repo_hash['repos'] || {})
    modulepath = (repo_hash['modulepath'] || default_modulepath)
    repos_to_clone = (repos['repo_paths'] || {})
    branches_to_checkout = (repos['checkout_branches'] || {})
    repos_to_clone.each do |remote, local|
      # I should check to see if the file is there?
      outpath = File.join(modulepath, local)
      output = `git clone #{remote} #{outpath}`
      puts output
    end
    branches_to_checkout.each do |local, branch|
      Dir.chdir(File.join(modulepath, local)) do
        output = `git checkout #{branch}`
      end
      # Puppet.debug(output)
    end
    FileUtils.cp('manifests/site.pp', 'razor-puppet-puppetdb-demo/manifests/site.pp')
  end
end
