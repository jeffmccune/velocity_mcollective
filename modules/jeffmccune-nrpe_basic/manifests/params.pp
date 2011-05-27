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
}
