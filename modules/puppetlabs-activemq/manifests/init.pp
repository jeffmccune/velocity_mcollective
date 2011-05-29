# Class: activemq
#
# This module manages the ActiveMQ messaging middleware.
#
# Parameters:
#
# Actions:
#
# Requires:
#
#   Class['java']
#
# Sample Usage:
#
# node default {
#   class { 'activemq': }
# }
#
class activemq(
  $version = 'present',
  $ensure  = 'running'
) {

  # Arrays cannot take anonymous arrays in Puppet 2.6.8
  $v_ensure = [ '^running$', '^stopped$' ]
  validate_re($ensure, $v_ensure)
  validate_re($version, '^[._0-9a-zA-Z:-]+$')

  $version_real = $version
  $ensure_real  = $ensure

  class { 'activemq::packages':
    version => $version_real,
  }

  class { 'activemq::config':
    require => Class['activemq::packages'],
  }

  class { 'activemq::service':
    ensure  => $ensure_real,
    require => Class['activemq::config'],
  }

}

