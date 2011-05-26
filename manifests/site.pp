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

  class { 'mcollective':
    server_config => template("site/server.cfg"),
    client_config => template("site/client.cfg"),
  }

}

node /^puppet/ inherits default {

  class { 'java': }
  class { 'activemq': }

  Class['activemq::service'] -> Class['mcollective::service']

}

