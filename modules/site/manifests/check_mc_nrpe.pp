# Class: site::check_mc_nrpe
#
#   Deploy a small script to aggregate nagios checks using MCollective.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class site::check_mc_nrpe {

  file { '/usr/sbin/check-mc-nrpe':
    ensure  => file,
    owner   => '0',
    group   => '0',
    mode    => '0755',
    content => template('site/mcollective/sbin/check-mc-nrpe'),
  }

  # Hack since puppet apply doesn't write classes.txt
  file { '/var/lib/puppet/state/classes.txt':
    ensure  => file,
    owner   => '0',
    group   => '0',
    mode    => '0644',
    content => "monitor\n",
  }

}
