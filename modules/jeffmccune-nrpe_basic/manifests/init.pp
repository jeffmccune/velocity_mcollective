# Class: nrpe_basic
#
# This module manages nrpe_basic
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class nrpe_basic(
  $config = undef
) {

  # JJM This can be any string, but we rely on it being
  # undefined if we're not managing it.
  $config_real = $config

  class { 'nrpe_basic::packages':
    stage  => 'setup_infra',
    notify => Class['nrpe_basic::service'],
  }

  class { 'nrpe_basic::config':
    stage   => 'setup_infra',
    config  => $config_real,
    require => Class['nrpe_basic::packages'],
    notify  => Class['nrpe_basic::service'],
  }

  class { 'nrpe_basic::service':
    stage => 'deploy_infra',
  }

}
