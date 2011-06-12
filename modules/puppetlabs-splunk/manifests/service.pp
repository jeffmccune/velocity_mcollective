# Class: splunk::service
#
#   Manage the splunk service.
#
# Parameters:
#
# Actions:
#
#   Creates a service in Puppet used
#   to control the running of the splunk
#   stack.
#
# Requires:
#
#
#   Class['splunk::users']
#   User['splunk']
#   Class['splunk::package']
#
# Sample Usage:
#
class splunk::service(
  $service_name = 'splunk',
  $ensure       = 'running',
  $enable       = true,
  $install_path = "${splunk::users::home}/bin"
) {

  exec { 'boot_enable':
    command => "${install_path}/splunk enable boot-start --accept-license",
    creates => '/etc/init.d/splunk',
    before  => Service['splunk'],
    require => Class['splunk::package'],
  }

  service { 'splunk':
    name       => $service_name,
    ensure     => $ensure,
    enable     => $enable,
    hasrestart => true,
    hasstatus  => false,
    pattern    => 'splunkd',
    start      => '/etc/init.d/splunk start --accept-license',
  }

}
