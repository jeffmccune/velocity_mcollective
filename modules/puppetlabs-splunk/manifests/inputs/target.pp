# Define: splunk::inputs::target
#
#   The high level define used to construct a fragment that will be used as a
#   file indexing target in inputs.conf.  The data contructed here is passed
#   onto the splunk::fragment define.
#
#   Cody Herriges <cody@puppetlabs.com>
#   2010-12-22
#
# Parameters:
#
# - **target**
#
# - **index**
#
# - **enable**
#
# - **ensure**
#
# - **app_id**
#
# Requires:
#
#   Class['splunk']
#   User['splunk']
#   Group['splunk']
#   Class['splunk::inputs']
#
# Sample Usage:
#
define splunk::inputs::target(
  $target,
  $index  = 'main',
  $enable = true,
  $ensure = 'present',
  $app_id = 'puppet_managed'
) {

  if ! ($ensure == 'present' or $ensure == 'absent') {
    fail('ensure must be present or absent')
  }

  if ! ($enable == true or $enable == false) {
    fail('enabled must be present or absent')
  }

  splunk::fragment { "01_targetfrag_${name}":
    content     => template('splunk/targetfrag.erb'),
    config_id   => 'inputs',
    app_id      => $app_id,
  }
}
