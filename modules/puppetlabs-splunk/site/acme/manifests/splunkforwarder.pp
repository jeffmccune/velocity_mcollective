class acme::splunkforwarder {
  class { 'splunk::users':
    virtual => false
  }
  class { 'splunk::package':
    pkg_base => 'http://ec2-75-101-174-83.compute-1.amazonaws.com',
    pkg_file => 'splunk-4.1.7-95063-linux-2.6-x86_64.rpm',
    has_repo => false,
  }
  class { 'splunk::service': }
  class { 'splunk': }
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
    server => 'ec2-50-17-158-62.compute-1.amazonaws.com,50.17.158.62:9999',
  }
  splunk::outputs::server { 'splunk':
    port            => '9999',
    password        => 'password',
    root_ca         => '$SPLUNK_HOME/etc/auth/cacert.pem',
    ssl_cert        => '$SPLUNK_HOME/etc/auth/server.pem',
    cn_check        => 'SplunkServerDefaultCert',
    validate_server => true,
  }
}
