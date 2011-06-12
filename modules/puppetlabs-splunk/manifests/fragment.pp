# Define: splunk::fragment
#
#   A low level define that creates a fragment to be used in the contruction of
#   a splunk application config file. The data contained in the fragment is
#   formatted and provided by a higher level define that is more narrowly
#   focused to produce a specific config file block.
#
# License:
#
#   Licensed under Apache 2.0.  Full license text can be found in LICENSE which
#   is shipped as part of this module, in it's root directory.
#
# Parameters:
#
# - **ensure**
#     This controls the creation of the file resource fragment.  If you set
#     this to absent you won't actually generate any fragments and so not
#     actually create a final config file.
#
# - **fragment_id**
#     This id is part of what dynamically generates the names of our fragments
#     and we use conditions from with in this define to set it automatically.
#     It will be set to $name unless you pass in a fragment_id from the the
#     parent defined resource.
#
# - **config_id**
#     We split up our fragments directories by which final config file they will
#     create.
#
# - **app_id**
#     This ties the fragment to a specific Splunk application which in turn
#     determines where the fragment will be placed in the fragment spool
#     directory structure.
#
# - **content**
#     What actully gets put in the fragment.  This is indended to be handed
#     to us from another collection, define or class.
#
# Requires:
#
#   Class['splunk']
#
# Sample Usage:
#
#   splunk::fragment { "03_serverfrag_${name}":
#     content     => template('splunk/serverfrag.erb'),
#     config_id   => 'outputs',
#     app_id      => $app_id,
#   }
#
define splunk::fragment(
  $ensure      = 'present',
  $fragment_id = '',
  $config_id,
  $app_id,
  $content
) {

  if ! ($ensure == 'present' or $ensure == 'absent') {
    fail('ensure must be present or absent')
  }

  if ($fragment_id == '') {
    $fragment_id_real = $name
  } else {
    $fragment_id_real = $fragment_id
  }

  # Local variable to help with length
  $local_appdir  = "${splunk::fragpath}/${app_id}"
  $local_fragdir = "${splunk::fragpath}/${app_id}/${config_id}.d"

  # Declare the spool directory, target file and exec rebuild once, the
  # first time a resource of type splunk::fragment is declared.
  if ! defined(File[$local_appdir]) {
    file { $local_appdir:
      ensure => directory,
      mode   => '0700',
      notify => Exec["rebuild_${app_id}_${config_id}"],
    }
  }

  if ! defined(File[$local_fragdir]) {
    file { $local_fragdir:
      ensure  => directory,
      recurse => true,
      purge   => true,
      mode    => '0700',
      notify  => Exec["rebuild_${app_id}_${config_id}"],
    }
  }

  if ! defined(Exec["rebuild_${app_id}_${config_id}"]) {
    exec { "rebuild_${app_id}_${config_id}":
      command     => "/bin/cat ${local_fragdir}/* > ${local_appdir}/${config_id}",
      refreshonly => true,
    }
  }

  # Manage the permissions on the spooled file.
  if ! defined(File["${local_appdir}/${config_id}"]) {
    file { "${local_appdir}/${config_id}":
      ensure  => file,
      mode    => '0600',
      require => Exec["rebuild_${app_id}_${config_id}"],
    }
  }

  # Manage the fragment.
  file { "${splunk::fragpath}/${app_id}/${config_id}.d/${fragment_id_real}":
    ensure  => $ensure,
    mode    => '0600',
    content => $content,
    notify  => Exec["rebuild_${app_id}_${config_id}"],
  }

}
