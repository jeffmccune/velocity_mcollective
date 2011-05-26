# Class: puppet::packages
#
#   This class manages the supplementary packages for Puppet
#   Note, it does not manage the Puppet and Facter packages themselves.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#

class puppet::packages(
  $dbtype                = "sqlite",
  $local_packages        = [ "rails", "activerecord", "activesupport" ],
  $rails_version         = "2.2.3",
  $activerecord_version  = "2.3.5",
  $activesupport_version = "2.3.5"
) {
  $module = "puppet"

  if $rails_version =~ /^(\d+\.)+\d$/ {
    $rails_version_real = $rails_version
  } else {
    fail("ERROR: rails_version must match x.y.z got ($rails_version)")
  }

  if $activerecord_version =~ /^(\d+\.)+\d$/ {
    $activerecord_version_real = $activerecord_version
  } else {
    fail("ERROR: activerecord_version must match x.y.z got ($activerecord_version)")
  }

  if $activesupport_version =~ /^(\d+\.)+\d$/ {
    $activesupport_version_real = $activesupport_version
  } else {
    fail("ERROR: activesupport_version must match x.y.z got ($activesupport_version)")
  }

  # TODO Support additional database types beyond sqlite.
  if $dbtype in [ "sqlite" ] {
    $dbtype_real = $dbtype
  } else {
    fail("ERROR: dbtype must be sqlite")
  }

  $local_packages_real = $local_packages
  $spool_real = $::puppet::spool_real

  if "rails" in $local_packages_real {
    $rails_source = "${spool_real}/puppet/rails-${rails_version_real}.gem"
    file { "${spool_real}/puppet/rails-${rails_version_real}.gem":
      ensure => file,
      source => "puppet:///modules/${module}/rails-${rails_version_real}.gem",
      owner  => 0,
      group  => 0,
      mode   => 0644,
      before => Package["rails"],
    }
  } else {
    $rails_source = undef
  } # if rails in ...

  if "activerecord" in $local_packages_real {
    $activerecord_source = "${spool_real}/puppet/activerecord-${activerecord_version_real}.gem"
    file { "${spool_real}/puppet/activerecord-${activerecord_version_real}.gem":
      ensure => file,
      source => "puppet:///modules/${module}/activerecord-${activerecord_version_real}.gem",
      owner  => 0,
      group  => 0,
      mode   => 0644,
      before => Package["activerecord"],
    }
  } else {
    $activerecord_source = undef
  } # if activerecord in ...

  if "activesupport" in $local_packages_real {
    $activesupport_source = "${spool_real}/puppet/activesupport-${activesupport_version_real}.gem"
    file { "${spool_real}/puppet/activesupport-${activesupport_version_real}.gem":
      ensure => file,
      source => "puppet:///modules/${module}/activesupport-${activesupport_version_real}.gem",
      owner  => 0,
      group  => 0,
      mode   => 0644,
      before => Package["activesupport"],
    }
  } else {
    $activesupport_source = undef
  } # if activesupport in ...

  # FIXME Does this require EPEL?
  case $dbtype_real {
    sqlite: {
      package { "sqlite":
        ensure => present,
        before => Package["ruby-sqlite"],
        tag    => "storeconfigs",
      }
      package { "ruby-sqlite":
        ensure => present,
        name   => "rubygem-sqlite3-ruby",
        tag    => "storeconfigs",
      }
      package { "activesupport":
        ensure   => $activesupport_version_real,
        source   => $activesupport_source,
        provider => gem,
        tag      => "storeconfigs",
        before   => Package["activerecord"],
      }
      package { "activerecord":
        ensure   => $activerecord_version_real,
        source   => $activerecord_source,
        provider => gem,
        tag      => "storeconfigs",
        before   => Package["rails"],
      }
      package { "rails":
        ensure   => $rails_version_real,
        source   => $rails_source,
        provider => gem,
        tag      => "storeconfigs",
      }


    } 
    default: {
      fail("ERROR: Should never get here.")
    }
  } # case $dbtype_real

  # JJM Packages should notify the Apache service to restart.
  Package <| tag == "storeconfigs" |> ~> Service["apache"]

}
