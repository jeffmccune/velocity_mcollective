class { 'splunk::users':
  virtual => false
}

class { 'splunk::package':
  pkg_base => 'http://192.168.135.1',
  pkg_file => 'splunk-4.1.6-89596-linux-2.6-x86_64.rpm',
  has_repo => false,
}

class { 'splunk::service': }

class { 'splunk':
  fragbase => '/var/lib/puppet/spool'
}
class { 'splunk::app': }
class { 'splunk::lwf': }
class { 'splunk::inputs': }
splunk::inputs::target {
  'yum':
    target => '/var/log/yum.log',
}
class { 'splunk::outputs': }
class { 'splunk::outputs::global':
  default_group => 'indexers',
}
splunk::outputs::group { 'indexers':
  server => 'splunk:9999',
}
splunk::outputs::server { 'splunk':
    port            => '9999',
    password        => 'password',
    root_ca         => '$SPLUNK_HOME/etc/auth/cacert.pem',
    ssl_cert        => '$SPLUNK_HOME/etc/auth/server.pem',
    cn_check        => 'SplunkServerDefaultCert',
    validate_server => true,
}
