node default {

  include stdlib
  include motd

  # Name resolution for the vagrant network
  class { 'site':
    baseurl => 'http://10.0.2.2',
  }

  # This is how users manage different platforms and configuration files
  # Another candidate for hiera
  # Also notice how as soon as the server configuration is specified,
  # the client configuration could potentially become out of sync
  # if the file doesn't match up with the class parameter.
  class { 'mcollective':
    stomp_server    => 'stomp',
    mc_security_psk => 'velocity2011',
    server_config   => $operatingsystem ? {
      ubuntu  => template('site/server.cfg.lucid'),
      default => template('site/server.cfg'),
    }
  }

  # NRPE for Monitoring
  class { 'nrpe_basic': }

  # NOTE Resources declarations should be avoided in the node definition.
  # Configure a nagios registration check that's FAST (3 second expiration)
  # for velocity.
  nrpe_basic::command { 'check_mcollective_fast':
    ensure     => 'present',
    command    => 'check_mcollective.rb',
    parameters => '--directory /var/tmp/mcollective --interval 3',
    require    => Nrpe_basic::Command['check_mcollective'],
  }

}

node puppet100 {

  include stdlib
  include motd

  # Name resolution for the vagrant network
  class { 'site':
    baseurl => 'http://10.0.2.2',
  }

  # This is how users manage different platforms and configuration files
  # Another candidate for hiera
  # Also notice how as soon as the server configuration is specified,
  # the client configuration could potentially become out of sync
  # if the file doesn't match up with the class parameter.
  class { 'mcollective':
    stomp_server    => 'stomp',
    mc_security_psk => 'velocity2011',
    client          => true,
    server_config   => $operatingsystem ? {
      ubuntu  => template('site/server.cfg.lucid'),
      default => template('site/server.cfg'),
    }
  }

  # NRPE for Monitoring
  class { 'nrpe_basic': }

  # NOTE Resources declarations should be avoided in the node definition.
  # Configure a nagios registration check that's FAST (3 second expiration)
  # for velocity.
  nrpe_basic::command { 'check_mcollective_fast':
    ensure     => 'present',
    command    => 'check_mcollective.rb',
    parameters => '--directory /var/tmp/mcollective --interval 3',
    require    => Nrpe_basic::Command['check_mcollective'],
  }

  # ActiveMQ needs the Java JDK
  class { 'java':
    distribution => 'jdk',
  }
  class { 'activemq':
    require => Class['java'],
  }

  Class['activemq::service'] -> Class['mcollective::server::service']

}

node monitor101 {

  include stdlib
  include motd

  # Name resolution for the vagrant network
  class { 'site':
    baseurl => 'http://10.0.2.2',
  }

  # This is how users manage different platforms and configuration files
  # Another candidate for hiera
  # Also notice how as soon as the server configuration is specified,
  # the client configuration could potentially become out of sync
  # if the file doesn't match up with the class parameter.
  class { 'mcollective':
    stomp_server    => 'stomp',
    mc_security_psk => 'velocity2011',
    client          => true,
    server_config   => $operatingsystem ? {
      ubuntu  => template('site/server.cfg.lucid'),
      default => template('site/server.cfg'),
    }
  }

  # NRPE for Monitoring
  class { 'nrpe_basic': }

  # NOTE Resources declarations should be avoided in the node definition.
  # Configure a nagios registration check that's FAST (3 second expiration)
  # for velocity.
  nrpe_basic::command { 'check_mcollective_fast':
    ensure     => 'present',
    command    => 'check_mcollective.rb',
    parameters => '--directory /var/tmp/mcollective --interval 3',
    require    => Nrpe_basic::Command['check_mcollective'],
  }

  ##  Add a splunk UI to the monitor.
  class { 'splunk::users':
    virtual => false
  }
  class { 'splunk::package':
    require => Class['splunk::users'],
  }
  class { 'splunk::service': }
  class { 'splunk':
    fragbase => '/var/lib/puppet/spool'
  }
  class { 'splunk::app': }
  class { 'splunk::inputs': }
  class { 'splunk::inputs::ssl':
    server_cert     => '$SPLUNK_HOME/etc/auth/server.pem',
    password        => 'password',
    root_ca         => '$SPLUNK_HOME/etc/auth/cacert.pem',
    validate_client => true,
  }
  splunk::inputs::target { 'messages':
    target => '/var/log/messages',
  }
  splunk::inputs::target { 'maillog':
    target => '/var/log/maillog';
  }
  splunk::inputs::receiver { '9999':
    ssl => true,
  }
  splunk::inputs::receiver { '9998': }

}
