class vagrant_puppet {

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

node default {

  include stdlib
  include motd

  # Setup yum repositories in an early stage
  class { 'puppetlabs_repos': stage => 'setup' }

  # This class disables the Puppet shipped with the VM
  # and installs puppet from packages
  class { 'vagrant_puppet': stage => runtime }

}

