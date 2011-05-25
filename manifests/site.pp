node default {

  include stdlib
  include motd

  class { 'puppetlabs_repos': stage => 'setup' }

  class { 'pupee': }

}

node /^puppet/ inherits default {

  class { 'java': }
  class { 'activemq': }

}

