# Class: puppet::loadbalancer
#
#   This class manages the front end HTTPS load balancer
#
#   Two clusters of workers are managed.  One cluster is for everything
#   _except_ certificate related requests.  The other cluster is for only
#   certificate related requests.
#
#   Future work may include setting up additional clusters for development and
#   testing, though these are largely provided by puppet environments.
#
#   Jeff McCune <jeff@puppetlabs.com> 2010-12-23
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#

class puppet::loadbalancer (
  $ssl_protocol           = false,
  $ssl_ciphersuite        = false,
  $ssl_cert_content       = false,
  $ssl_cert_key_content   = false,
  $ssl_cert_chain_content = false,
  $ssl_ca_cert_content    = false,
  $ssl_ca_crl_content     = false
) {

  if $ssl_protocol == false {
    $ssl_protocol_real = $::puppet::params::ssl_protocol
    notice("Using ssl_protocol from puppet::params::ssl_protocol (${ssl_protocol_real})")
  } else {
    $ssl_protocol_real = $ssl_protocol
    notice("Using ssl_protocol from specified class parameter (${ssl_protocol_real})")
  }

  if $ssl_ciphersuite == false {
    $ssl_ciphersuite_real = $::puppet::params::ssl_ciphersuite
    notice("Using ssl_ciphersuite from puppet::params::ssl_ciphersuite (${ssl_ciphersuite_real})")
  } else {
    $ssl_ciphersuite_real = $ssl_ciphersuite
    notice("Using ssl_ciphersuite from specified class parameter (${ssl_ciphersuite_real})")
  }

  if $ssl_cert_content == false {
    $ssl_cert_content_real = $::puppet::params::ssl_cert_content
    notice("Using ssl_cert_content from puppet::params::ssl_cert_content (${ssl_cert_content_real})")
  } else {
    $ssl_cert_content_real = $ssl_cert_content
    notice("Using ssl_cert_content from specified class parameter (${ssl_cert_content_real})")
  }

  if $ssl_cert_key_content == false {
    $ssl_cert_key_content_real = $::puppet::params::ssl_cert_key_content
    notice("Using ssl_cert_key_content from puppet::params::ssl_cert_key_content (${ssl_cert_key_content_real})")
  } else {
    $ssl_cert_key_content_real = $ssl_cert_key_content
    notice("Using ssl_cert_key_content from specified class parameter (${ssl_cert_key_content_real})")
  }

  if $ssl_cert_chain_content == false {
    $ssl_cert_chain_content_real = $::puppet::params::ssl_cert_chain_content
    notice("Using ssl_cert_chain_content from puppet::params::ssl_cert_chain_content (${ssl_cert_chain_content_real})")
  } else {
    $ssl_cert_chain_content_real = $ssl_cert_chain_content
    notice("Using ssl_cert_chain_content from specified class parameter (${ssl_cert_chain_content_real})")
  }

  if $ssl_ca_cert_content == false {
    $ssl_ca_cert_content_real = $::puppet::params::ssl_ca_cert_content
    notice("Using ssl_ca_cert_content from puppet::params::ssl_ca_cert_content (${ssl_ca_cert_content_real})")
  } else {
    $ssl_ca_cert_content_real = $ssl_ca_cert_content
    notice("Using ssl_ca_cert_content from specified class parameter (${ssl_ca_cert_content_real})")
  }

  if $ssl_ca_crl_content == false {
    $ssl_ca_crl_content_real = $::puppet::params::ssl_ca_crl_content
    notice("Using ssl_ca_crl_content from puppet::params::ssl_ca_crl_content (${ssl_ca_crl_content_real})")
  } else {
    $ssl_ca_crl_content_real = $ssl_ca_crl_content
    notice("Using ssl_ca_crl_content from specified class parameter (${ssl_ca_crl_content_real})")
  }

  $module = "puppet"

  $spool_real = $::puppet::spool_real

  file { "${spool_real}/loadbalancer":
    ensure => directory,
    owner  => 0,
    group  => 0,
    mode   => 0755,
  }

  puppet::frontend { "puppet_prod":
    identifier             => puppet_prod,
    port                   => 8140,
    ssl_protocol           => $ssl_protocol_real,
    ssl_ciphersuite        => $ssl_ciphersuite_real,
    ssl_cert_content       => $ssl_cert_content_real,
    ssl_cert_key_content   => $ssl_cert_key_content_real,
    ssl_cert_chain_content => $ssl_cert_chain_content_real,
    ssl_ca_cert_content    => $ssl_ca_cert_content_real,
    ssl_ca_crl_content     => $ssl_ca_crl_content_real,
    ssl_drop_unverified    => false,
    ssl_verify_depth       => 3,
    proxy_status           => true,
  }

  puppet::frontend { "puppet_test":
    identifier             => puppet_test,
    port                   => 8141,
    ssl_protocol           => $ssl_protocol_real,
    ssl_ciphersuite        => $ssl_ciphersuite_real,
    ssl_cert_content       => $ssl_cert_content_real,
    ssl_cert_key_content   => $ssl_cert_key_content_real,
    ssl_cert_chain_content => $ssl_cert_chain_content_real,
    ssl_ca_cert_content    => $ssl_ca_cert_content_real,
    ssl_ca_crl_content     => $ssl_ca_crl_content_real,
    ssl_drop_unverified    => false,
    ssl_verify_depth       => 3,
    proxy_status           => true,
  }

  puppet::frontend { "puppet_dev":
    identifier             => puppet_dev,
    port                   => 8142,
    ssl_protocol           => $ssl_protocol_real,
    ssl_ciphersuite        => $ssl_ciphersuite_real,
    ssl_cert_content       => $ssl_cert_content_real,
    ssl_cert_key_content   => $ssl_cert_key_content_real,
    ssl_cert_chain_content => $ssl_cert_chain_content_real,
    ssl_ca_cert_content    => $ssl_ca_cert_content_real,
    ssl_ca_crl_content     => $ssl_ca_crl_content_real,
    ssl_drop_unverified    => false,
    ssl_verify_depth       => 3,
    proxy_status           => true,
  }

}
# EOF
