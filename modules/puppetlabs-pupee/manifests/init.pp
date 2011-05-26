# Class: pupee
#
# This module manages the packages provided by Puppet Enterprise
# without necessarily managing Puppet Itself.
#
# This is primarily intended for development and testing of additional
# things on top of the Puppet Enterprise runtime environment.
#
# Jeff McCune <jeff@puppetlabs.com>
# 2011-05-25
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#   include pupee
#
class pupee ($srcdir='/usr/local/src') {

  validate_re($srcdir, '^/')
  $srcdir_real = $srcdir

  class { 'pupee::ruby':
    stage => 'runtime',
  }
  class { 'pupee::envpuppet':
    require => Class['pupee::ruby'],
    srcdir  => $srcdir_real,
    stage   => 'runtime',
  }

}
