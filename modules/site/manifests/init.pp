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

}
