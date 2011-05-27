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

	package { 'nagios-plugins-all': }
  -> package { 'nagios-plugins-file_age': }
  -> package { 'nagios-plugins': }
  -> package { 'nrpe': }

}
