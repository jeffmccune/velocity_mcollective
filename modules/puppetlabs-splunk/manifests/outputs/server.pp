# Define: splunk::outputs::server
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
define splunk::outputs::server(
  $app_id          = 'puppet_managed',
  $enable          = true,
  $index_forward   = false,
  $send_cooked     = true,
  $compress        = false,
  $max_queue       = '1000',
  $ssl_cert        = '',
  $password        = '',
  $root_ca         = '',
  $validate_server = false,
  $cn_check        = '',
  $cnalt_check     = '',
  $port
) {

  splunk::fragment { "03_serverfrag_${name}":
    content     => template('splunk/serverfrag.erb'),
    config_id   => 'outputs',
    app_id      => $app_id,
  }
}
