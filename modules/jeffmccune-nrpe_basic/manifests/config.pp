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
  $config = undef,
  $cplugdir = 'auto'
) inherits nrpe_basic::params {

  $config_real = $config

  # if we overrode cplugdir then use that, else go with the nagios default for
  # this architecture
  # JJM FEATURE data this parameter is duplicated in the nrpe_basic::command
  # defined resource type.  It's a potential candidate for data in modules or
  # heira or something.
  $plugdir = $cplugdir ? {
    'auto'  => $defaultdir,
    default => $cplugdir,
  }

  # Quick hack to deploy the aggregate nagios check.
  # This should really be a defined resource type the end
  # user may consume.
  file { "${plugdir}/check_mcollective.rb":
    ensure  => file,
    content => template("nrpe_basic/check_mcollective.rb"),
    owner   => '0',
    group   => '0',
    mode    => '0755',
  }

  nrpe_basic::command { 'check_puppet_run':
    ensure     => 'present',
    command    => 'check_file_age',
    parameters => '-f /var/lib/puppet/state/state.yaml -w 5400 -c 7200',
  }

  # This is a basic check of the file ages for the registration
  # information.  If a node drops off the collective without being
  # unregistered, the check will notify for that system.
  nrpe_basic::command { 'check_mcollective':
    ensure     => 'present',
    command    => 'check_mcollective.rb',
    parameters => '--directory /var/tmp/mcollective',
    require    => File["${plugdir}/check_mcollective.rb"],
  }

  file { '/etc/nagios/nrpe.cfg':
    ensure  => 'file',
    owner   => '0',
    group   => '0',
    mode    => '644',
    content => $config_real,
  }

}
