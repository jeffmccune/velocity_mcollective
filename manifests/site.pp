node default {

  include stdlib
  include motd

  class { 'puppetlabs_repos': stage => 'setup' }

}

node /^puppet/ inherits default {

  class { 'java': }
  class { 'activemq': }

}

