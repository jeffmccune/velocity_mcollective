node default {

  include stages
  include motd

  class { 'puppetlabs_repos': stage => 'setup' }

}

node /^puppet/ inherits default {

  class { 'java': version => '1.6.0_25-fcs' }

}

