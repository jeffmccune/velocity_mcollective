# Define: splunk::outputs
#
#   Cody Herriges <cody@puppetlabs.com>
#   2011-1-18
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class splunk::outputs(
  $app_id = 'puppet_managed'
) {

  splunk::fragment { '00_header_outputs':
    content   => '# This file is managed by puppet and will be overwritten',
    config_id => 'outputs',
    app_id    => $app_id,
  }

  file { "${splunk::app::apppath}/${app_id}/default/outputs.conf":
    source  => "${splunk::fragpath}/${app_id}/outputs",
    mode    => '0644',
    owner   => 'splunk',
    group   => 'splunk',
    require => File["${splunk::fragpath}/${app_id}/outputs"],
    notify  => Service['splunk'],
  }
}
