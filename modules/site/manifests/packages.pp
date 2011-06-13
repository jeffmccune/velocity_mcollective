# Class: site::packages
#
#   Deploy specific packages for this demo.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class site::packages {

  # Make facter available to MCollective.
  # For mco inventory to work, the facter libraries need to be in the
  # $LOAD_PATH.  Rather than hack the init script for mcollective to use
  # something like envpuppet, it's better to just disable facter in
  # /usr/local/src/facter and install it "normally"
  package { 'facter':
    ensure => latest,
  }
  file { '/usr/local/bin/facter':
    ensure  => absent,
    require => Package['facter'],
  }
  exec { 'mv /usr/local/src/facter /usr/local/src/facter.disable':
    path    => "/bin:/usr/bin",
    creates => '/usr/local/src/facter.disable',
    require => [ Package['facter'], File['/usr/local/bin/facter'] ],
  }

}
