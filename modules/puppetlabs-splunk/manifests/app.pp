# Class: splunk::app
#
#   Creates the initial app.conf and it's parent directories for the portion of
#   Splunk being managed by Puppet.
#
# License:
#
#   Licensed under Apache 2.0.  Full license text can be found in LICENSE which
#   is shipped as part of this module, in it's root directory.
#
# Parameters:
#
#   Default parameters are sane enough that someone will have a fully functional
#   installation without having to use the parameterized class syntax.
#
#   - **enable**
#       If the app you configured with Puppet is actually enabled in Splunk.
#       Any config stored in this app with not function unless that app is
#       enabled.
#
#   - **ensure**
#       This simply controls the existance of the app.conf files its self.
#       You could use this class to construct the directory structure but
#       no actually use the Puppet generated app.conf.
#
#   - **basepath**
#       We grab the Splunk user home directory from the Class['splunk::users'].
#       If you do not control the Splunk user from within Puppet you will need
#       override this value.
#
#   - **app_id**
#       Name of the Splunk application that Puppet creates.  This can be set
#       because we plan to evolve this into a dynamic module that can deploy
#       an arbitrary number of Splunk applications.  If you override this you
#       need to remember to override if for every other piece of this module
#       that can take a app_id parameter.
#
# Requires:
#
#   Class['splunk']
#   User['splunk']
#
# Sample Usage:
#
#   class { 'splunk::app': }
#
class splunk::app(
  $enable    = true,
  $ensure    = 'present',
  $basepath  = $splunk::users::home,
  $app_id    = 'puppet_managed'
  ) {

  if ! ($ensure == 'present' or $ensure == 'absent') {
    fail('ensure must be present or absent')
  }

  if ! ($enable == true or $enable == false) {
    fail('enable must be true or false')
  }

  $apppath = "${basepath}/etc/apps"

  $paths = [
      "${basepath}",
      "${basepath}/etc/",
      "${apppath}",
      "${apppath}/${app_id}",
      "${apppath}/${app_id}/default",
  ]

  file { $paths:
      ensure => directory,
      owner  => 'splunk',
      group  => 'splunk',
      mode   => '0755',
  }

  file { "${apppath}/$app_id/default/app.conf":
    ensure => $ensure,
    owner  => 'splunk',
    group  => 'splunk',
    mode   => '0644',
    content => template('splunk/appconf.erb'),
  }
}
