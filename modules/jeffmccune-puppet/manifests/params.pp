class puppet::params {
  $confdir = "/etc/puppet"
  $vardir  = "/var/lib/puppet"
  $logdir  = "/var/log/puppet"
  $rundir  = "/var/run/puppet"
  $rackdir = "/var/lib/puppet/rack"
  $uid     = "52"
  $gid     = "52"
  $home    = "/var/lib/puppet"
  $spool   = "/var/lib/puppet/spool"
  $shell   = "/sbin/nologin"
  $ssl_protocol           = "-ALL +SSLv3 +TLSv1"
  $ssl_ciphersuite        = "ALL:!ADH:RC4+RSA:+HIGH:+MEDIUM:-LOW:-SSLv2:-EXP"
  $ssl_cert_content       = template("puppet/ssl_cert")
  $ssl_cert_key_content   = template("puppet/ssl_cert_key")
  $ssl_cert_chain_content = template("puppet/ssl_cert_chain")
  $ssl_ca_cert_content    = template("puppet/ssl_ca_cert")
  $ssl_ca_crl_content     = template("puppet/ssl_ca_crl")
}

