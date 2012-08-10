require 'yaml'

class String
  def to_bool
    return true if self == true || self =~ (/(true|t|yes|y|1)$/i)
    return false if self == false || self.blank? || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end

if ENV['USE_PE']
  use_pe = ENV['USE_PE'].to_bool
  vagrant_env = 'full-pe'
else
  use_pe = false
  vagrant_env ='full-noosimage'
end

repo_file = 'other_repos.yaml'

alias :core_system :system

def system (cmd)
  result = core_system cmd
  raise RuntimeError unless $?.success?
  result
end

def on_box (box, cmd)
  system("vagrant ssh #{box} -c '#{cmd}'")
end

namespace :openstack_demo do

  desc 'install the puppet master with razor, dhcp, and puppetdb'
  task :install_master do

    # install razor-puppet-puppetdb-demo.git
    unless File.directory? 'razor-puppet-puppetdb-demo'
      system('git clone git://github.com/branan/razor-puppet-puppetdb-demo.git')
    end

    Dir.chdir('razor-puppet-puppetdb-demo/') do

      # install all module dependencies
      system('librarian-puppet install --verbose')
      raise :RuntimeError unless $?.success?
      # bring up a master
      if use_pe
        Dir.chdir('env/full-pe') do
          FileUtils.cp '../../../files/puppet-enterprise-2.5.3-ubuntu-12.04-amd64.tar.gz', './'
            system('vagrant up master')
        end
      else
        Dir.chdir('env/full-noosimage') do
          system('vagrant up master')
        end
      end

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
      if File.directory? outpath
        Dir.chdir(outpath) do
          system("git pull")
        end
      else
        system("git clone #{remote} #{outpath}")
      end
    end
    branches_to_checkout.each do |local, branch|
      Dir.chdir(File.join(modulepath, local)) do
        system("git checkout #{branch}")
      end
    end
    FileUtils.cp('manifests/site.pp', 'razor-puppet-puppetdb-demo/manifests/site.pp')
    if File.exists? "razor-puppet-puppetdb-demo/env/#{vagrant_env}/model"
      FileUtils.rm_rf "razor-puppet-puppetdb-demo/env/#{vagrant_env}/model"
    end
    FileUtils.cp_r('files/model', "razor-puppet-puppetdb-demo/env/#{vagrant_env}/model")
  end

  desc 'configure Razor to deploy openstack'
  task :configure_razor do
    Dir.chdir("razor-puppet-puppetdb-demo/env/#{vagrant_env}") do
      on_box 'master', 'sudo chown -R puppet:puppet /var/lib/puppet/'
      if use_pe
        puppet_tags = "pe"
      else
        puppet_tags = "os"
      end
      core_system("vagrant ssh master -c 'sudo puppet agent --test --waitforcert 1 --tags #{puppet_tags}'")
    end
  end

  desc 'fetch the base operating system image'
  task :fetch_image do
    Dir.chdir("razor-puppet-puppetdb-demo/env/#{vagrant_env}") do
      unless File.exists? 'ubuntu-12.04-server-amd64.iso'
        if File.exists? '../../../files/ubuntu-12.04-server-amd64.iso':
            FileUtils.cp '../../../files/ubuntu-12.04-server-amd64.iso', './'
        else
          system('curl -L http://releases.ubuntu.com/precise/ubuntu-12.04-server-amd64.iso -o ubuntu-12.04-server-amd64.iso')
        end
      end
    end
  end

  task :fetch_pe do
    Dir.chdir('files') do
      unless File.exists? 'puppet-enterprise-2.5.3-ubuntu-12.04-amd64.tar.gz'
        system('curl -L https://pm.puppetlabs.com/puppet-enterprise/2.5.3/puppet-enterprise-2.5.3-ubuntu-12.04-amd64.tar.gz -o puppet-enterprise-2.5.3-ubuntu-12.04-amd64.tar.gz')
      end
    end
  end
end

namespace :deploy do
  task :razor do
    Rake::Task['openstack_demo:install_master'.to_sym].invoke
    Rake::Task['openstack_demo:fetch_image'.to_sym].invoke
    Rake::Task['openstack_demo:setup'.to_sym].invoke
    Rake::Task['openstack_demo:configure_razor'.to_sym].invoke
    system("vagrant up")
  end
end
