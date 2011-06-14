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
class site(
  $baseurl = 'http://www',
  $manage_hosts = false
) {

  validate_re($baseurl, '^http://')
  $baseurl_real = $baseurl

  File {
    owner  => '0',
    group  => '0',
    mode   => '0644',
  }

  $distribution = inline_template("<%= '${operatingsystem}'.downcase %>")
  $codename     = inline_template("<%= '${lsbdistcodename}'.downcase %>")
  $prosvc_key   = template("${module_name}/APT-GPG-KEY-prosvc")

  if $manage_hosts {
    $hosts_content = template("site/hosts")
  } else {
    $hosts_content = undef
  }
  file { '/etc/hosts':
    owner   => '0',
    group   => '0',
    mode    => '0644',
    content => $hosts_content
  }

  case $operatingsystem {
    ubuntu: {
        class { 'apt': }
        -> exec { "apt-key prosvc":
          command => "/bin/bash -c '/usr/bin/apt-key add - <<END_OF_KEY\n${prosvc_key}\nEND_OF_KEY'",
          unless  => "/usr/bin/apt-key list | /bin/grep ED41696E",
        }
        -> apt::source { 'prosvc':
          location          => "${baseurl_real}/apt/prosvc/${distribution}",
          release           => $codename,
          repos             => 'main',
          include_src       => true,
          required_packages => false,
          key               => 'ED41696E',
          key_server        => 'keyserver.ubuntu.com',
          pin               => '600',
        }
    }
    redhat, centos, oel: {

      # Don't let cron crush our system
      file { '/etc/cron.daily/makewhatis.cron':
        ensure => absent,
      }
      file { '/etc/cron.daily/mlocate.cron':
        ensure => absent,
      }
      file { '/etc/cron.daily/rpm':
        ensure => absent,
      }

      # Manage yum repositories
      file { '/etc/yum.repos.d':
        ensure  => directory,
        recurse => true,
        purge   => true,
        notify  => Exec['yum_clean'],
      }
      file { '/etc/yum.repos.d/prosvc.repo':
        content => template("${module_name}/prosvc.repo.erb"),
        notify  => Exec['yum_clean'],
      }
      file { '/etc/yum.repos.d/centos.repo':
        content => template("${module_name}/centos.repo.erb"),
        notify  => Exec['yum_clean'],
      }
      file { '/etc/yum.repos.d/java.repo':
        content => template("${module_name}/java.repo.erb"),
        notify  => Exec['yum_clean'],
      }
      file { '/etc/yum.repos.d/pupee.repo':
        content => template("${module_name}/pupee.repo.erb"),
        notify  => Exec['yum_clean'],
      }
      file { '/etc/yum.repos.d/mcollective.repo':
        content => template("${module_name}/mcollective.repo.erb"),
        notify  => Exec['yum_clean'],
      }
      file { '/etc/yum.repos.d/extras.repo':
        content => template("${module_name}/extras.repo.erb"),
        notify  => Exec['yum_clean'],
      }

      exec { 'yum_clean':
        command     => '/usr/bin/yum clean all',
        refreshonly => true,
      }

      file { '/var/tmp/RPM-GPG-KEY-prosvc':
        content => $prosvc_key
      }

      exec { 'yum_prosvc_key':
        command => '/bin/rpm --import /var/tmp/RPM-GPG-KEY-prosvc',
        unless  => '/bin/rpm -q gpg-pubkey-ed41696e-4d9dfc86',
        require => File['/var/tmp/RPM-GPG-KEY-prosvc'],
      }

    }

  }

  # The fix for facter has been moved here
  class { 'site::packages': }

  # Make sure yum|apt and name resolution are configured
  # Before any packages are installed.
  Class['site'] -> Package <||>

}

