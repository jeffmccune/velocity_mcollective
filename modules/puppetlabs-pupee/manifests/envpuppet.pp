# Class: pupee::envpuppet
#
#   This class manages envpuppet wrapper scripts for use with the
#   Puppet Enterprise ruby runtime.
#
#   The idea is that if you want Puppet to use the PE gem binary,
#   you also want to manage the PATH very carefully.
#
#   To accomplish this, /usr/local/bin/puppet will be a wrapper
#   script managed by this class, will use envpuppet to run
#   puppet directly from a Git repository, and will manage the
#   path for you.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class pupee::envpuppet(
  $ruby   = '/opt/puppet/bin/ruby',
  $bindir = '/usr/local/bin',
  $srcdir = '/usr/local/src',
  $path   = '/opt/puppet/bin:/sbin:/usr/sbin:/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin'

) {

  # Must be a fully qualified path
  validate_re($ruby,   '^/')
  validate_re($path,   '^/')
  validate_re($path,   ':' )
  validate_re($bindir, '^/')
  validate_re($srcdir, '^/')
  $ruby_real   = $ruby
  $bindir_real = $bindir
  $srcdir_real = $srcdir
  $path_real   = $path

  File {
    owner => '0',
    group => '0',
    mode  => '0755',
  }

  file { "${bindir_real}/envpuppet":
    content => template("${module_name}/envpuppet.erb"),
  }
  file { "${bindir_real}/puppet":
    content => template("${module_name}/puppet.erb"),
    require => File["${bindir_real}/envpuppet"],
  }
  file { "${bindir_real}/facter":
    content => template("${module_name}/facter.erb"),
    require => File["${bindir_real}/envpuppet"],
  }

}
