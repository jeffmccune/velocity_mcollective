# Class: nrpe_basic::params
#
#   Parameters for the NRPE module.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class nrpe_basic::params {
  $libdir_param = $architecture ? {
    'x86_64' => 'lib64',
    default  => 'lib',
  }
  $nrpe_dir = $operatingsystem ? {
    /(?i-mx:centos|fedora|redhat|oel)/ => '/etc/nrpe.d',
    default                            => '/etc/nagios/nrpe.d',
  }

# find out the default nagios paths for plugis
  $defaultdir = $::architecture ? {
    "x86_64" => "/usr/lib64/nagios/plugins",
    default  => "/usr/lib/nagios/plugins",
  }

}
