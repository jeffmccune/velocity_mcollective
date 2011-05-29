# Define: nrpe_basic::command
#
#   Manage a command in /etc/nrpe.d
#
#   Copied from mcollective-plugins github project.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
define nrpe_basic::command(
  $command,
  $parameters = '',
  $cplugdir   = 'auto',
  $ensure     = 'present'
) {

# find out the default nagios paths for plugis
  $defaultdir = $::architecture ? {
    "x86_64" => "/usr/lib64/nagios/plugins",
    default  => "/usr/lib/nagios/plugins",
  }

# if we overrode cplugdir then use that, else go with the nagios default
# for this architecture
  case $cplugdir {
    'auto':    { $plugdir = $defaultdir }
    default: { $plugdir = $cplugdir }
  }


  case $ensure {
    "absent":    {
      file{"/etc/nrpe.d/${name}.cfg":
        ensure => absent,
        notify => Class['nrpe_basic::service'],
      }
    }
    default: {
      file {"/etc/nrpe.d/${name}.cfg":
        owner   => '0',
        group   => '0',
        mode    => '0644',
        content => template("${module_name}/nrpe-config.erb"),
        notify  => Class['nrpe_basic::service'],
      }
    }
  }
}
# EOF
