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

  Package { ensure => installed }

	package { 'nagios-plugins-all': }
  -> package { 'nagios-plugins-file_age': }
  -> package { 'nagios-plugins': }
  -> package { 'nrpe': }


}
