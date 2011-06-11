require 'yaml'

begin
  require 'facter'
  FACTER_LOADED = true
rescue LoadError
  FACTER_LOADED = false
end

@dnsdomain = FACTER_LOADED ? Facter[:domain].value : 'UNKNOWN'
@at_puppetlabs = @dnsdomain =~ /puppetlabs.lan$/ ? true : false

Vagrant::Config.run do |config|

  # Change this box name depending on the system you want.
  # box = "rhel60_64"
  # box = "centos4_64"
  box = "centos56_64"
  url = @at_puppetlabs ? "http://faro.puppetlabs.lan/vagrant" : "https://puppetlabs.s3.amazonaws.com/pub"

  # What internal network should these hosts be on? (24 bit network)
  network = "172.20.10"

  # Boot with a GUI so you can see the screen. (Default is headless)
  config.vm.boot_mode = :gui

  # This will provision the box using puppet
  config.vm.define :puppet100 do |node|
    node.vm.box = "#{box}"
    node.vm.box_url = "#{url}/#{box}.box"
    node.vm.provision :shell, :path => 'shell/puppet100'
    node.vm.provision :puppet do |puppet|
      puppet.options        = "-v --vardir=/var/lib/puppet --ssldir=/var/lib/puppet/ssl"
      puppet.module_path    = "modules"
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "vagrant.pp"
    end
    node.vm.customize do |vm|
      vm.memory_size = 2048
      vm.cpu_count   = 2
    end
    node.vm.forward_port("ssh", 22, 22100)
    node.vm.forward_port("dashboard", 3000, 3000)
    node.vm.forward_port("puppet",    8140, 8140)
    node.vm.network("#{network}.100")
  end

  # Web hosts
  # %w{ 21 22 23 24 }.each do |offset|
  %w{ 21 }.each do |offset|
    config.vm.define "www#{offset}".to_sym do |node|
      node.vm.box = "#{box}"
      node.vm.box_url = "#{url}/#{box}.box"
      node.vm.customize do |vm|
        vm.memory_size = 384
        vm.cpu_count   = 1
      end
      node.vm.provision :shell, :path => "shell/www#{offset}"
      node.vm.provision :puppet do |puppet|
        puppet.options        = "-v --vardir=/var/lib/puppet --ssldir=/var/lib/puppet/ssl"
        puppet.module_path    = "modules"
        puppet.manifests_path = "manifests"
        puppet.manifest_file  = "vagrant.pp"
      end
      node.vm.forward_port("ssh", 22, "220#{offset}".to_i)
      node.vm.network("#{network}.#{offset}")
    end
  end

  # Database hosts
  %w{ 41 }.each do |offset|
    config.vm.define "db#{offset}".to_sym do |node|
      node.vm.box     = "lucid64"
      node.vm.box_url = "#{url}/#{box}.box"
      node.vm.customize do |vm|
        vm.memory_size = 768
        vm.cpu_count   = 2
      end
      node.vm.provision :shell, :path => "shell/db#{offset}"
      node.vm.provision :puppet do |puppet|
        puppet.options        = "-v --vardir=/var/lib/puppet --ssldir=/var/lib/puppet/ssl"
        puppet.module_path    = "modules"
        puppet.manifests_path = "manifests"
        puppet.manifest_file  = "vagrant.pp"
      end
      node.vm.forward_port("ssh", 22, "220#{offset}".to_i)
      node.vm.network("#{network}.#{offset}")
    end
  end

end

# vim:ft=ruby
