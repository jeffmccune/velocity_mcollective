# Define: splunk::inputs::receiver
#
#   The high level define used to construct a fragment that will be used as a
#   receiver of data from a Splunk forwarder.  The data contructed here is
#   passed onto the splunk::fragment define.
#
#   Cody Herriges <cody@puppetlabs.com>
#   2010-12-22
#
# Parameters:
#
# - **ensure**
#
# - **enable**
#
# - **port**
#
# - **app_id**
#
# - **ssl**
#
# Requires:
#
#   Class['splunk']
#   User['splunk']
#   Group['splunk']
#   Class['splunk::inputs']
#
#
# Sample Usage:
#
define splunk::inputs::receiver(
  $ensure   = 'present',
  $enable   = true,
  $port     = '',
  $app_id   = 'puppet_managed',
  $ssl      = false
) {

  if ! ($ensure == 'present' or $ensure == 'absent') {
    fail('ensure must be present or absent')
  }

  if ! ($enable == true or $enable == false) {
    fail('enabled must be present or absent')
  }

  if ($port == '') {
    $port_real = $name
  } else {
    $port_real = $port
  }

  splunk::fragment { "02_receiverfrag_${name}":
    content     => template('splunk/receiverfrag.erb'),
    config_id   => "inputs",
    app_id      => $app_id,
  }
}
