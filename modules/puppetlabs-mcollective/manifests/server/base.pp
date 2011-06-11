# Class: mcollective::server::base
#
#   This class installs the MCollective server component for your nodes.
#
# Parameters:
#
#  [*version*]            - The version of the MCollective package(s) to
#                             be installed.
#  [*config*]             - The content of the MCollective client configuration
#                             file.
#  [*config_file*]        - The full path to the MCollective client
#                             configuration file.
# Actions:
#
# Requires:
#
# Sample Usage:
#
class mcollective::server::base(
  $version,
  $config,
  $config_file
) inherits mcollective::params {

  # Manage the packge (RPM or DEB)
  class { 'mcollective::server::package':
    version => $version,
    notify  => Class['mcollective::server::service'],
  }

  # Manage the configuration file
  class { 'mcollective::server::config':
    config      => $config,
    config_file => $config_file,
    require     => Class['mcollective::server::package'],
    notify      => Class['mcollective::server::service'],
  }

  # Manage the service
  class { 'mcollective::server::service': }
}

