# Define: splunk::inputs::ssl
#
#   The high level define used to construct a fragment that will be used as a
#   SSL block in a Splunk reciever's inputs.conf  The data contructed here is
#   passed onto the splunk::fragment define.
#
#   Cody Herriges <cody@puppetlabs.com>
#   2010-12-22
#
# Parameters:
#
# - **server_cert**
#
# - **password**
#
# - **root_ca**
#
# - **dhfile**
#
# - **validate_client**
#
# - **enable**
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
class splunk::inputs::ssl(
  $server_cert,
  $password = 'password',
  $root_ca,
  $dhfile = '',
  $validate_client = false,
  $enable = true,
  $app_id = 'puppet_managed'
) {

  if ! ($enable == true or $enable == false) {
    fail('enable must be true or false')
  }

  splunk::fragment { '03_sslfrag':
    content     => template('splunk/sslfrag.erb'),
    app_id      => $app_id,
    config_id   => 'inputs',
    ensure      => $enable ? {
      true  => 'present',
      false => 'absent',
    },
  }
}
