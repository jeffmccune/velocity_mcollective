# Class: splunk::package
#
#   This functions as a facility for installing the Splunk package.  We do some
#   stuff as an attempt to extrapolate package providers that are or aren't
#   central repository based.
#
# Parameters:
#
# - **pkg_name**
#
# - **pkg_base**
#
# - **pkg_file**
#
# - **has_repo**
#
# - **provider**
#
# - **ensure**
#
# Requires:
#
#   User['splunk']
#
# Sample Usage:
#
class splunk::package(
  $pkg_name   = 'splunk',
  $pkg_base   = '',
  $pkg_file   = '',
  $has_repo   = true,
  $provider   = '',
  $ensure     = 'present'
) inherits splunk::params {
  # JJM Note, this should break out to platform specific
  # secondary classes.  They should NOT be subclasses.

  if ! ($ensure == 'absent' or $ensure == 'present') {
    fail('ensure param must be absent or present')
  }

  if ($pkg_base == '' and $pkg_file == '' and $has_repo == false) {
    fail("if you have not put the splunk package in a repo you must provide a pkg_base location and a pkg_file name")
  }

  # JJM Ideally, the customer would have a local yum repository,
  # but this is often not the case, so we need to install
  # from URL.

  # Cody:  This basically overcomes the fact that some operating system default
  # providers are not repo based.  We identify a default non-repo based and a
  # repo based provider for each OS this modules supports.

  if ($has_repo == false and $provider == '') {
    $provider_real   = $splunk::params::no_repo_provider
  } elsif ($has_repo == true and $provider == '' ) {
    $provider_real   = $splunk::params::repo_provider
    $pkg_source      = undef
  } elsif ($provider != '') {
    $provider_real   = $provider
  } else {
    fail('has_repo must be true or false')
  }

  if ($has_repo == false and $pkg_file == '') {
    $pkg_source = "${pkg_base}/${splunk::params::pkg_file}"
  } elsif ($has_repo == false and $pkg_file != '') {
    $pkg_source = "${pkg_base}/${pkg_file}"
  }

  # End sanity checking
  # Begin resource declarations

  package { "splunk":
    name     => $pkg_name,
    ensure   => $ensure,
    provider => $provider_real,
    source   => $pkg_source,
  }

  # Relationships
  if ($ensure == 'present'and defined (User['splunk'])) {
    User['splunk'] -> Package['splunk']
  }
}
