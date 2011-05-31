# Class: puppetlabs_repos
#
#   Manage repository configuration for Yum
#
# Parameters:
#
# Actions:
#
# Requires:
#
#   Class['stdlib']
#
# Sample Usage:
#
class puppetlabs_repos(
  $baseurl = 'http://10.0.2.2/yum'
) {

  $baseurl_real = $baseurl

  case $operatingsystem {
    centos, redhat, oel : {
      class { 'puppetlabs_repos::redhat':
        baseurl => $baseurl_real,
        stage   => setup
      }
    }
    default: {
      notice("Not managing repositories on operatingsystem $operatingsystem")
    }
  }

}

