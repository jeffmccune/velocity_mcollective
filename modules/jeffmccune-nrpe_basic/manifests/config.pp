# Class: nrpe_basic::config
#
#   Manage the configuration skeleton for NRPE
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class nrpe_basic::config(
  $config = undef
) inherits nrpe_basic::params {

  $config_real = $config

  nrpe_basic::command { 'check_puppet_run':
    ensure     => 'present',
    command    => 'check_file_age',
    parameters => '-f /var/lib/puppet/state/state.yaml -w 5400 -c 7200',
  }

  file { '/etc/nagios/nrpe.cfg':
    ensure  => 'file',
    owner   => '0',
    group   => '0',
    mode    => '644',
    content => $config_real,
  }

}
