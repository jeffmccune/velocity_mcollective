# Class: nrpe_basic::packages
#
#   Packages for NRPE
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class nrpe_basic::packages {

  Package { ensure => installed }

  case $operatingsystem {
    centos, redhat, oel: {
      package { 'nagios-plugins-all': }
      -> package { 'nagios-plugins-file_age': }
      -> package { 'nagios-plugins': }
      -> package { 'nrpe': }
    }
    debian, ubuntu: {
      package { 'nagios-plugins-basic': }
      -> package { 'nagios-nrpe-server': }
    }
    default: {
      fail("operatingsystem $operatingsystem is not supported")
    }
  }


}
