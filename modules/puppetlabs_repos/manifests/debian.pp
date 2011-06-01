# Class: puppetlabs_repos::debian
#
#   Manage a local repository for Debian
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class puppetlabs_repos::debian(
  $baseurl
) {

  $baseurl_real = $baseurl

  $os = inline_template("<%= '$operatingsystem'.downcase %>")

  File {
    owner => '0',
    group => '0',
    mode  => '0644',
  }

  exec { 'aptitude_update':
    command     => 'aptitude update',
    path        => '/bin:/usr/bin:/sbin:/usr/sbin',
    refreshonly => true,
  }

  file { 'puppetlabs_repos':
    path    => '/etc/apt/sources.list.d/puppetlabs_repo.list',
    content => "deb ${baseurl_real}/${os}/ ${lsbdistcodename} main\n",
    notify  => Exec['aptitude_update'],
  }

  # JJM HUGE PROBLEM FIXME WARNING WARNING WARNING
  file { 'ignore_trust_violations':
    ensure  => file,
    path    => '/etc/apt/apt.conf.d/99untrusted',
    content => 'Aptitude::CmdLine::Ignore-Trust-Violations "true";',
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    before  => File['puppetlabs_repos'],
    notify  => Exec['aptitude_update'],
  }


}

