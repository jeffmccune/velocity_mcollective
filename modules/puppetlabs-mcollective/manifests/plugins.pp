# Class: mcollective::plugins
#
#   This class deploys the default set of MCollective
#   plugins
#
# Parameters:
#
# Actions:
#
# Requires:
#
#   Class['mcollective']
#   Class['mcollective::service']
#
# Sample Usage:
#
#   This class is intended to be declared in the mcollective class.
#
class mcollective::plugins(
  $plugin_base = $mcollective::params::plugin_base,
  $plugin_subs = $mcollective::params::plugin_subs
) inherits mcollective::params {

  file { $plugin_base:
    ensure  => directory,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    require => Class['mcollective::server::pkg'],
  }

  file { $plugin_subs:
    ensure => directory,
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
    notify => Class['mcollective::server::service'],
  }

  mcollective::plugins::plugin { 'registration':
    ensure      => present,
    type        => 'agent',
    ddl         => false,
    application => false,
  }
  mcollective::plugins::plugin { 'facter_facts':
    ensure => present,
    type   => 'facts',
  }
  mcollective::plugins::plugin { 'yaml_facts':
    ensure => present,
    type   => 'facts',
  }
  mcollective::plugins::plugin { 'service':
    ensure      => present,
    type        => 'agent',
    ddl         => true,
    application => true,
  }
  mcollective::plugins::plugin { 'package':
    ensure      => present,
    type        => 'agent',
    ddl         => true,
    application => true,
  }
  mcollective::plugins::plugin { 'meta':
    ensure      => present,
    type        => 'registration',
    ddl         => false,
    application => false,
  }

}
