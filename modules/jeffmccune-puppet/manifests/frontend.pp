# Define: puppet::frontend
#
#   This defined type models an Apache Load Balancer Front end.
#
#   Certificates are handled by passing in the raw PEM encoded contents of each
#   required file.
#
#   The load balancer instance identifier determines which worker exported
#   resources will be added to the pool.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#

define puppet::frontend(
  $identifier=false,
  $port="8140",
  $ssl_protocol="-ALL +SSLv3 +TLSv1",
  $ssl_ciphersuite="ALL:!ADH:RC4+RSA:+HIGH:+MEDIUM:-LOW:-SSLv2:-EXP",
  $ssl_cert_content,
  $ssl_cert_key_content,
  $ssl_cert_chain_content,
  $ssl_ca_cert_content,
  $ssl_ca_crl_content,
  $ssl_drop_unverified=false,
  $ssl_verify_depth="1",
  $proxy_status=true
) {

  if $identifier == false {
    $identifier_real = $name
  } else {
    $identifier_real = $identifier
  }

  if $port =~ /^\d+$/ {
    $port_real = $port
  } else {
    fail("ERROR: port parameter must be numeric")
  }

  # FIXME Better validation is required here.
  $ssl_protocol_real = $ssl_protocol
  $ssl_ciphersuite_real = $ssl_ciphersuite

  if $ssl_cert_content =~ /BEGIN CERTIFICATE/ {
    $ssl_cert_content_real = $ssl_cert_content
  } else {
    fail("ERROR: ssl_cert_content must be a PEM encoded CERTIFICATE")
  }

  if $ssl_cert_key_content =~ /BEGIN RSA PRIVATE KEY/ {
    $ssl_cert_key_content_real = $ssl_cert_key_content
  } else {
    fail("ERROR: ssl_cert_key_content must be a PEM encoded RSA PRIVATE KEY")
  }

  # TODO Work out better validations of these resource parameters.
  $ssl_cert_chain_content_real = $ssl_cert_chain_content
  $ssl_ca_cert_content_real    = $ssl_ca_cert_content
  $ssl_ca_crl_content_real     = $ssl_ca_crl_content

  if $ssl_drop_unverified == false {
    $ssl_drop_unverified_real = false
    $ssl_verify_client = "optional"
  } elsif $ssl_drop_unverified == true {
    $ssl_drop_unverified_real = true
    $ssl_verify_client = "require"
  } else {
    fail("ERROR: ssl_drop_unverified must be true or false")
  }

  if $ssl_verify_depth =~ /^\d+$/ and ( $ssl_verify_depth < 10 and $ssl_verify_depth > 0) {
    $ssl_verify_depth_real = $ssl_verify_depth
  } else {
    fail("ERROR: ssl_verify_depth must be in the range 1...9")
  }

  if $proxy_status == true {
    $proxy_status_real = "On"
  } elsif $proxy_status == false {
    $proxy_status_real = "Off"
  } else {
    fail("ERROR: proxy_status must be true or false")
  }

  # Spool directory for snippets.
  $spool_real = $::puppet::spool_real

  # TODO: Fill in the Apache configuration template

  file { "${spool_real}/loadbalancer/frontend_${identifier_real}":
    ensure => directory,
    owner  => 0,
    group  => 0,
    mode   => "0755",
  }

  # Load Balancer workers will have file fragments collected into this
  # directory.
  file { "${spool_real}/loadbalancer/frontend_${identifier_real}/members.d":
    ensure  => directory,
    owner   => 0,
    group   => 0,
    mode    => "0755",
    recurse => true,
    purge   => true,
  } ~> Service <| title == "apache" |>

  # File fragment directory for load balancer workers who are CA's.  There
  # should only be one or two of these.
  file { "${spool_real}/loadbalancer/frontend_${identifier_real}/members.ca.d":
    ensure  => directory,
    owner   => 0,
    group   => 0,
    mode    => "0755",
    recurse => true,
    purge   => true,
  } ~> Service <| title == "apache" |>

  # SSL Certificates for Apache
  file { "${spool_real}/loadbalancer/frontend_${identifier_real}/ssl_cert.pem":
    ensure  => file,
    content => $ssl_cert_content_real,
    owner   => 0,
    group   => 0,
    mode    => 0644,
    before  => Apache::Config["frontend_${identifier_real}"],
    notify  => Service["apache"],
  }
  file { "${spool_real}/loadbalancer/frontend_${identifier_real}/ssl_cert_key.pem":
    ensure  => file,
    content => $ssl_cert_key_content_real,
    owner   => 0,
    group   => 0,
    mode    => 0400,
    before  => Apache::Config["frontend_${identifier_real}"],
    notify  => Service["apache"],
  }
  file { "${spool_real}/loadbalancer/frontend_${identifier_real}/ssl_cert_chain.pem":
    ensure  => file,
    content => $ssl_cert_chain_content_real,
    owner   => 0,
    group   => 0,
    mode    => 0644,
    before  => Apache::Config["frontend_${identifier_real}"],
    notify  => Service["apache"],
  }
  file { "${spool_real}/loadbalancer/frontend_${identifier_real}/ssl_ca_cert.pem":
    ensure  => file,
    content => $ssl_ca_cert_content_real,
    owner   => 0,
    group   => 0,
    mode    => 0644,
    before  => Apache::Config["frontend_${identifier_real}"],
    notify  => Service["apache"],
  }
  file { "${spool_real}/loadbalancer/frontend_${identifier_real}/ssl_ca_crl.pem":
    ensure  => file,
    content => $ssl_ca_crl_content_real,
    owner   => 0,
    group   => 0,
    mode    => 0644,
    before  => Apache::Config["frontend_${identifier_real}"],
    notify  => Service["apache"],
  }

  apache::config { "frontend_${identifier_real}":
    content  => template("puppet/puppet_frontend_XXXX.conf"),
    filename => "010_frontend_${identifier_real}.conf",
  }

  # Collect all exported puppet::member resources by the frontend identifier.
  Puppet::Member <<| frontend == "${identifier_real}" |>> ~> Service <| title == "apache" |>

}
