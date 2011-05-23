node default {

  include stages
  include motd

  class { 'puppetlabs_repos': stage => 'setup' }

}

