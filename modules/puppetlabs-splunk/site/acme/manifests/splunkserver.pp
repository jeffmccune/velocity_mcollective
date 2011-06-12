class acme::splunkserver {
  notice "Splunk Server"
  class { 'splunk::users':
    virtual => false
  }
  class { 'splunk::package':
    require => Class['splunk::users'],
    pkg_base => 'http://ec2-75-101-174-83.compute-1.amazonaws.com',
    pkg_file => 'splunk-4.2.1-98164-linux-2.6-x86_64.rpm',
    has_repo => false,
  }
  class { 'splunk::service': }
  class { 'splunk': }
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
