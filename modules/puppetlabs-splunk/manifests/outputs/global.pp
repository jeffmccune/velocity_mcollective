# Define: splunk::outputs:global
#
#   Cody Herriges <cody@puppetlabs.com>
#   2010-01-28
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class splunk::outputs::global(
  $app_id          = 'puppet_managed',
  $default_group   = '',
  $enable          = true,
  $index_forward   = false,
  $send_cooked     = true,
  $compress        = false,
  $max_queue       = '1000',
  $auto_lb         = false,
  $ssl_cert        = '',
  $password        = '',
  $root_ca         = '',
  $validate_server = false,
  $cn_check        = '',
  $cnalt_check     = ''
) {

  splunk::fragment { '01_globalfrag':
    content     => template('splunk/globalfrag.erb'),
    config_id   => 'outputs',
    app_id      => $app_id,
  }
}
