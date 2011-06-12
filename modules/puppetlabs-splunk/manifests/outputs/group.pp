# Define: splunk::outputs::group
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
define splunk::outputs::group(
  $app_id          = 'puppet_managed',
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
  $cnalt_check     = '',
  $server
) {

  splunk::fragment { "02_groupfrag_${name}":
    content     => template('splunk/groupfrag.erb'),
    config_id   => 'outputs',
    app_id      => $app_id,
  }
}
