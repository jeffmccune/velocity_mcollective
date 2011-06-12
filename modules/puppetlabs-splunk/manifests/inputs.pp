# Define: splunk::inputs
#
#   Sets up a warning header for inputs.conf and copies our spooled together
#   inputs file to the proper location.
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
class splunk::inputs(
  $app_id = 'puppet_managed'
) {

  splunk::fragment { '00_header_inputs':
		content   => '# This file is managed by puppet and will be overwritten',
		config_id => 'inputs',
		app_id    => $app_id,
  }

  # We explicitly declare the relationship to the parent directory
  # because it appears a require metaparameter overrides the implicit
  # dependency entirely.
  file { "${splunk::app::apppath}/${app_id}/default/inputs.conf":
    source  => "${splunk::fragpath}/${app_id}/inputs",
    mode    => '0644',
    owner   => 'splunk',
    group   => 'splunk',
    require => [ File["${splunk::fragpath}/${app_id}/inputs"],
                 File["${splunk::app::apppath}/${app_id}/default"], ],
    notify  => Service['splunk'],
  }

}
