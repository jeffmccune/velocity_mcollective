node default {

  include stdlib
  include motd

  # Name resolution for the vagrant network
  class { 'site':
    baseurl => 'http://10.0.2.2',
    stage   => 'setup',
  }

  class { 'mcollective':
    stomp_server    => 'stomp',
    mc_security_psk => 'velocity2011'
  }

  # NRPE for Monitoring
  class { 'nrpe_basic': }

}

node /^puppet/ inherits default {

  # ActiveMQ needs the Java JDK
  class { 'java': distribution => 'jdk' }
  class { 'activemq': }

  # Override the mcollective class declared in the default node
  # to make sure the client interface is installed and managed
  Class['mcollective'] { client => true }

  # Make sure the ActiveMQ service is managed before the MCollective
  # service comes online
  Class['activemq::service'] -> Class['mcollective::server::service']

}

