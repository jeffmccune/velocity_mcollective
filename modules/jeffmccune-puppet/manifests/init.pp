class puppet(
  $confdir = false,
  $vardir  = false,
  $logdir  = false,
  $rundir  = false,
  $rackdir = false,
  $uid     = false,
  $gid     = false,
  $home    = false,
  $spool   = false,
  $shell   = false
) {

  $module = "puppet"

  if ($confdir == false) {
    $confdir_real = $puppet::params::confdir
    notice("Setting confdir_real using puppet::params::confdir (${confdir_real})")
  } else {
    $confdir_real = $confdir
    notice("Setting confdir_real using class parameter (${confdir_real})")
  }

  if ($vardir == false) {
    $vardir_real = $puppet::params::vardir
    notice("Setting vardir_real using puppet::params::vardir (${vardir_real})")
  } else {
    $vardir_real = $vardir
    notice("Setting vardir_real using class parameter (${vardir_real})")
  }

  if ($logdir == false) {
    $logdir_real = $puppet::params::logdir
    notice("Setting logdir_real using puppet::params::logdir (${logdir_real})")
  } else {
    $logdir_real = $logdir
    notice("Setting logdir_real using class parameter (${logdir_real})")
  }

  if ($rundir == false) {
    $rundir_real = $puppet::params::rundir
    notice("Setting rundir_real using puppet::params::rundir (${rundir_real})")
  } else {
    $rundir_real = $rundir
    notice("Setting rundir_real using class parameter (${rundir_real})")
  }

  if ($rackdir == false) {
    $rackdir_real = $puppet::params::rackdir
    notice("Setting rackdir_real using puppet::params::rackdir (${rackdir_real})")
  } else {
    $rackdir_real = $rackdir
    notice("Setting rackdir_real using class parameter (${rackdir_real})")
  }

  if ($uid == false) {
    $uid_real = $puppet::params::uid
    notice("Setting uid_real using puppet::params::uid (${uid_real})")
  } else {
    $uid_real = $uid
    notice("Setting uid_real using class parameter (${uid_real})")
  }

  if ($gid == false) {
    $gid_real = $puppet::params::gid
    notice("Setting gid_real using puppet::params::gid (${gid_real})")
  } else {
    $gid_real = $gid
    notice("Setting gid_real using class parameter (${gid_real})")
  }

  if ($home == false) {
    $home_real = $puppet::params::home
    notice("Setting home_real using puppet::params::home (${home_real})")
  } else {
    $home_real = $home
    notice("Setting home_real using class parameter (${home_real})")
  }

  if ($spool == false) {
    $spool_real = $puppet::params::spool
    notice("Setting spool_real using puppet::params::spool (${spool_real})")
  } else {
    $spool_real = $spool
    notice("Setting spool_real using class parameter (${spool_real})")
  }

  if ($shell == false) {
    $shell_real = $puppet::params::shell
    notice("Setting shell_real using puppet::params::shell (${shell_real})")
  } else {
    $shell_real = $shell
    notice("Setting shell_real using class parameter (${shell_real})")
  }

  user { "puppet":
    ensure  => present,
    uid     => "${uid_real}",
    gid     => "${gid_real}",
    comment => "Puppet",
    home    => "${home_real}",
    shell   => "${shell_real}",
    tag     => "puppetconf",
  }
  group { "puppet":
    ensure => present,
    gid    => "${gid_real}",
    tag    => "puppetconf",
  }

  file { [ "${vardir_real}",
           "${rundir_real}",
           "${rackdir_real}",
           "${spool_real}",
           "${spool_real}/puppet",
          ]:
    ensure => directory,
    owner  => "puppet",
    group  => "puppet",
    mode   => "0755",
    tag    => "puppetskel",
  }

  file { "${vardir_real}/state":
    ensure => directory,
    owner  => "puppet",
    group  => "puppet",
    mode   => "1755",
    tag    => "puppetskel",
  }

  file { "${logdir_real}":
    ensure => directory,
    owner  => "puppet",
    group  => "puppet",
    mode   => "0750",
    tag    => "puppetskel",
  }

  package { "facter":
    ensure => present,
    tag    => "puppetconf",
  }

  package { "puppet":
    ensure  => present,
    require => Package["facter"],
    tag     => "puppetconf",
  }

  package { "puppet-server":
    ensure  => present,
    require => Package["puppet"],
    tag     => "puppetconf",
  }

  # Relationships
  # JJM Feedback from NK - Don't rely on tags.
  User    <| tag == "puppetconf" |> -> Package <| tag == "puppetconf" |>
  Group   <| tag == "puppetconf" |> -> Package <| tag == "puppetconf" |>
  File    <| tag == "puppetskel" |> -> Package <| tag == "puppetconf" |>
  Package <| tag == "puppetconf" |> -> File    <| tag == "puppetconf" |>

}
