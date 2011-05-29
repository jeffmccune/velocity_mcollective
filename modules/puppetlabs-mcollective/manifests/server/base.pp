class mcollective::server::base(
  $version,
  $config,
  $config_file,
  $pkg_provider = $mcollective::params::pkg_provider
) inherits mcollective::params {

  class { 'mcollective::server::pkg':
    version      => $version,
    pkg_provider => $pkg_provider,
  }
  class { 'mcollective::server::config':
    config      => $config,
    config_file => $config_file,
    require     => Class['mcollective::server::pkg'],
  }
  class { 'mcollective::server::service':
    require => [ Class['mcollective::server::config'],
                 Class['mcollective::server::pkg'], ],
  }

}
