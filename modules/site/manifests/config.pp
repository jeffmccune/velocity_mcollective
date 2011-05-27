# Class: site::config
#
#   Site configuration for the demo
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class site::config {

  notify { "nrpe":
    message => "Configure nrpe here.",
  }

}
