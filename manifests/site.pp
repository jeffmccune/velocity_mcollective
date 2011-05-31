class vagrant_puppet {

  case $operatingsystem {
    centos, redhat, oel: {
      package { 'puppet':
        ensure => 'latest',
      }
      file { '/usr/local/bin/puppet':
        ensure => absent,
      }
      file { '/usr/local/bin/facter':
        ensure => absent,
      }

      file { '/etc/cron.daily/makewhatis.cron':
        ensure => absent,
      }
      file { '/etc/cron.daily/mlocate.cron':
        ensure => absent,
      }
      file { '/etc/cron.daily/rpm':
        ensure => absent,
      }
    }
    default: {
      notice("Using pre-installed puppet on $operatingsystem")
    }
  }

}

node default {

  include stdlib
  include motd

  # Name resolution for the vagrant network
  class { 'site': stage => 'setup' }

  # Setup yum repositories in an early stage
  class { 'puppetlabs_repos': stage => 'setup' }

  # This class disables the Puppet shipped with the VM
  # and installs puppet from packages
  class { 'vagrant_puppet': stage => runtime }

  class { 'mcollective': mc_security_psk => 'velocity2011' }

  # NRPE for Monitoring
  class { 'nrpe_basic': }

}

node /^puppet/ inherits default {

  class { 'java': }
  class { 'activemq': }

  Class['activemq::service'] -> Class['mcollective']

}

