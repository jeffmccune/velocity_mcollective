node default {

  include stdlib
  include motd

  # Name resolution for the vagrant network
  class { 'site':
    baseurl => 'http://10.0.2.2',
  }

}

