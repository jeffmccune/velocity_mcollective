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
class nrpe_basic {

  class { 'nrpe_basic::packages':
    stage => 'setup_infra',
  }

  class { 'nrpe_basic::service':
    stage => 'deploy_infra',
  }

}
