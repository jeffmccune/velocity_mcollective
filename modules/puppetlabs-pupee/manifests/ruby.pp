# Class: pupee::ruby
#
#   This class manages the deployment of the Puppet Enterprise
#   ruby packages.
#
#   It is assumed you have these hosted and available in an
#   accessible repository.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#   include puppee::ruby
#
class pupee::ruby {

  Package { ensure => installed }

  package { 'pe-ruby-libs': }
  package { 'pe-ruby':
    require => Package['pe-ruby-libs'],
  }
  package { 'pe-ruby-irb':
    require => Package['pe-ruby'],
  }
  package { 'pe-ruby-devel':
    require => Package['pe-ruby-libs'],
  }
  package { 'pe-rubygems':
    require => Package['pe-ruby'],
  }
  package { 'pe-rubygem-rake':
    require => Package['pe-rubygems'],
  }

}
