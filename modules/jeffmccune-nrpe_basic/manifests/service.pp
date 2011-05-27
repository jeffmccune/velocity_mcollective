# Class: nrpe_basic::service
#
#   Manage the NRPE service
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class nrpe_basic::service {

	service { 'nrpe':
		ensure     => running,
		enable     => true,
		hasstatus  => true,
		hasrestart => true,
	}

}
