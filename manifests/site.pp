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

node puppet100 {

  include stdlib
  include motd

  # Name resolution for the vagrant network
  class { 'site':
    baseurl => 'http://10.0.2.2',
    stage   => 'setup',
  }

  class { 'mcollective':
    stomp_server    => 'stomp',
    mc_security_psk => 'velocity2011',
    client          => true,
  }

  # NRPE for Monitoring
  class { 'nrpe_basic': }

  # ActiveMQ needs the Java JDK
  class { 'java': distribution => 'jdk' }
  class { 'activemq': }

  Class['activemq::service'] -> Class['mcollective::server::service']

}

