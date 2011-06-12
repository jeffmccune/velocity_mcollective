# Class: splunk
#
#   This is the jumping off point for the Splunk module.  It provides some
#   basic tooling that enables the proper generation of configs files.
#
#   Jeff McCune <jeff@puppetlabs.com>
#   Cody Herriges <cody@puppetlabs.com>
#
#
# Parameters:
#
#   - **fragbase**
#       The base directory where file fragments are staged for config file
#       generation.  We use a default that is current agreed upon by Puppet
#       Labs Professional Services team.
#
# Requires:
#
#       User['puppet']
#       Group['puppet']
#       File['/var/opt/lib/pe-puppet']
#         This is a loose requirement as it is configurable at class declaration
#         time.
#
# Sample Usage:
#
#       class { 'splunk':
#         fragbase => '/var/lib/puppet/spool',
#       }
#
class splunk (
  $fragbase = '/var/opt/lib/pe-puppet/spool'
) {

  $fragpath = "${fragbase}/splunk.d"

  # We will create a module for fragment directories.

  if ! defined(File[$fragbase]) {
    file { $fragbase:
      ensure => directory,
      mode   => '0700',
      owner  => root,
      group  => root,
    }
  }

  file { $fragpath:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    purge   => true,
    recurse => true,
  }

}
