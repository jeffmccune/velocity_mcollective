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
# Sample Usage:
#
class puppetlabs_repos(
  $baseurl = 'http://10.0.2.2/yum'
) {

  $baseurl_real = $baseurl

  File {
    owner  => '0',
    group  => '0',
    mode   => '0644',
    notify => Exec['yum_clean'],
  }

  file { '/etc/yum.repos.d':
    ensure  => directory,
    recurse => true,
    purge   => true,
  }
  file { '/etc/yum.repos.d/prosvc.repo':
    content => template("${module_name}/prosvc.repo.erb"),
  }
  file { '/etc/yum.repos.d/centos.repo':
    content => template("${module_name}/centos.repo.erb"),
  }
  file { '/etc/yum.repos.d/java.repo':
    content => template("${module_name}/java.repo.erb"),
  }
  file { '/etc/yum.repos.d/pupee.repo':
    content => template("${module_name}/pupee.repo.erb"),
  }
  file { '/etc/yum.repos.d/mcollective.repo':
    content => template("${module_name}/mcollective.repo.erb"),
  }
  file { '/etc/yum.repos.d/extras.repo':
    content => template("${module_name}/extras.repo.erb"),
  }

  exec { 'yum_clean':
    command     => '/usr/bin/yum clean all',
    refreshonly => true,
  }

}

