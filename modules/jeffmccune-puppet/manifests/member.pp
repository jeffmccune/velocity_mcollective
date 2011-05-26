# Define: puppet::member
#
#   This defined resource type models the simple configuration of an Apache
#   balancer member directive.
#
#   Puppet workers should export a resource of this type to be collected by the
#   front end load balancer.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#

define puppet::member(
  $frontend,
  $loadfactor,
  $ca=false,
  $url,
  $hot_standby=false
) {

  if $frontend {
    $frontend_real = $frontend
  } else {
    fail("ERROR: frontend must be a string value")
  }

  if $loadfactor > 0 and $loadfactor <= 100 {
    $loadfactor_real = $loadfactor
  } else {
    fail("ERROR: loadfactor must be between 1 and 100")
  }

  if $ca == true or $ca == false {
    $ca_real = $ca
  } else {
    fail("ERROR: ca must be true or false")
  }

  if $url =~ /^http/ {
    $url_real = $url
  } else {
    fail("ERROR: url must be a http URL")
  }

  if $hot_standby == true {
    $hot_standby_real  = true
    $hot_standby_flags = "status=+H"
  } elsif $hot_standby == false {
    $hot_standby_real  = false
    $hot_standby_flags = "status=-H"
  } else {
    fail("ERROR: hot_standby must be true or false")
  }

  $spool_real = $::puppet::spool_real

  if $ca_real {
    $prefix = "${spool_real}/loadbalancer/frontend_${frontend_real}/members.ca.d"
  } else {
    $prefix = "${spool_real}/loadbalancer/frontend_${frontend_real}/members.d"
  }

  file { "${prefix}/${name}.conf":
    ensure  => file,
    content => "BalancerMember ${url} ${hot_standby_flags} loadfactor=${loadfactor_real}\n",
    owner   => 0,
    group   => 0,
    mode    => 0644,
  }

}
# EOF
