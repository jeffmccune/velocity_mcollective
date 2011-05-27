# Class: site
#
#   Site specific stuff for this vagrant network
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class site {

  file { '/etc/hosts':
    owner   => '0',
    group   => '0',
    mode    => '0644',
    content => template("site/hosts"),
  }

  class { 'site::packages':
    stage  => 'setup_infra',
  }

  -> class { 'site::config':
    stage => 'setup_infra',
  }

  -> Class['mcollective::service']

}
