# Class: splunk::users
#
#   Virtual users for splunk.
#   These should be managed prior to installing the RPM package.
#
#   Jeff McCune <jeff@puppetlabs.com>
#   2010-12-10
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class splunk::users(
  $uid_number = undef,
  $gid_number = undef,
  $home       = '/opt/splunk',
  $ensure     = 'present',
  $virtual    = true
) {

  if ! ($ensure == 'present' or $ensure == 'absent') {
    fail('ensure must be present or absent')
  }

  # statements

  # We test for both because we fail otherwise and if virtual
  # is false, we just realize the virtual resource right here.
  if ($virtual == true or $virtual == false) {

    @user { 'splunk':
      ensure  => $ensure,
      uid     => $uid_number,
      gid     => 'splunk',
      home    => $home,
      shell   => '/bin/bash',
      comment => 'Splunk Server',
    }
    @group { 'splunk':
      ensure => $ensure,
      gid    => $gid_number,
    }

  } else {
    fail('virtual param must be true for false')
  }

  # Now realize the users if necessary.
  if ($virtual == false) {

    # Realize the virtual users.
    User  <| title == 'splunk' |>
    Group <| title == 'splunk' |>

    # Check if we're removing, flip the relationship direction.
    if ($ensure == 'present') {
      Group['splunk'] -> User['splunk']
    } elsif ($ensure == 'absent') {
      User['splunk']  -> Group['splunk']
    }

  } # if

}
