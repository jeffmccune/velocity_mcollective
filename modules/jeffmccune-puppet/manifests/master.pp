# Define: puppet::master
#
#   This defined resource types models and manages the Puppet master Apache
#   virtual host.  It supports both SSL termination and non_ssl termination for
#   the Apache virtual host to work nicely with a load balancer configuration.
#
#   Jeff McCune <jeff@puppetlabs.com>
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#

define puppet::master(
  $identifier        = false,
  $terminate_ssl     = false,
  $ca                = true,
  $confdir           = false,
  $rackdir           = false,
  $certname          = false,
  $ssldir            = false,
  $autosign          = false,
  $storeconfigs      = false,
  $thin_storeconfigs = true,
  $dbadapter         = false,
  $conf_contents     = false,
  $interface         = "*",
  $port              = "8140"
) {

  # Pull in variables from initial class.
  $vardir_real = $puppet::vardir_real
  $logdir_real = $puppet::logdir_real
  $rundir_real = $puppet::rundir_real

  # Input selection
  if $terminate_ssl == true or $terminate_ssl == false {
    $terminate_ssl_real = $terminate_ssl
  } else {
    fail("terminate_ssl parameter must be true or false.  Got: ($terminate_ssl)")
  }

  if $ca == true or $ca == false {
    $ca_real = $ca
  } else {
    fail("ca parameter must be true or false")
  }

  if $confdir == false {
    $confdir_real = $puppet::confdir_real
    notice("setting confdir using \$puppet::confdir_real (${confdir_real})")
  } else {
    $confdir_real = $confdir
    notice("setting confdir using parameter (${confdir_real})")
  }

  if $ssldir == false {
    $ssldir_real = "${puppet::vardir_real}/ssl"
    notice("setting ssldir using \$puppet::vardir_real (${ssldir_real})")
  } else {
    $ssldir_real = $ssldir
    notice("setting ssldir using parameter (${ssldir_real})")
  }
  if $ssldir_real == "" or $ssldir_real == false {
    fail("ERROR: For some reason, ssldir_real ($ssldir_real) is not set properly.")
  }

  if $identifier == false {
    $identifier_real = $name
    notice("setting identifier using title (${identifier_real})")
  } else {
    $identifier_real = $identifier
    notice("setting identifier using parameter (${identifier_real})")
  }

  if $certname == false {
    $certname_real = $fqdn
    notice("setting certname using fqdn (${certname_real})")
  } else {
    $certname_real = $certname
    notice("setting certname using parameter (${certname_real})")
  }

  $interface_real = $interface
  $port_real = $port

  if $rackdir == false {
    $rackdir_real = "${puppet::vardir_real}/rack/${identifier_real}_${port_real}"
    notice("setting rackdir using puppet class: (${rackdir_real})")
  } else {
    $rackdir_real = $rackdir
    notice("setting rackdir using parameter: (${rackdir_real})")
  }

  if $autosign == false {
    $autosign_real = false
    $autosign_string = "# Autosign is turned off via puppet::master resource"
  } else {
    $autosign_real = true
    $autosign_string = inline_template('<%= autosign.collect { |l| l }.join("\n") %>')
  }

  if $storeconfigs == false {
    $storeconfigs_real = false
  } elsif $storeconfigs == true {
    $storeconfigs_real = true
  } else {
    fail("storeconfigs parameter must be true or false")
  }

  if $thin_storeconfigs == false {
    $thin_storeconfigs_real = false
  } elsif $thin_storeconfigs == true {
    $thin_storeconfigs_real = true
  } else {
    fail("thin_storeconfigs parameter must be true or false")
  }

  if $dbadapter == false {
    $dbadapter_real = false
  } elsif $dbadapter in [ "sqlite3", "mysql" ] {
    $dbadapter_real = $dbadapter
  } else {
    fail("dbadapter must be in [ sqlite3, mysql ], got ($dbadapter)")
  }

  # Allow the consumer of this module to specify custom puppet.conf contents.
  # This is necessary for the load balancer configuration.
  if $conf_contents == false {
    $conf_contents_real = template("puppet/puppet.conf")
  } else {
    $conf_contents_real = $conf_contents
  }

  # Validation
  if ! $rackdir_real =~ /^\// {
    fail("rackdir must be an absolute path")
  }
  if ! $confdir_real =~ /^\// {
    fail("confdir must be an absolute path")
  }
  if ! $port_real =~ /^[0-9]+$/ {
    fail("port must be numeric")
  }

  # Rack Configuration

  file { [ "$rackdir_real",
           "${rackdir_real}/public",
           "${rackdir_real}/tmp", ]:
    ensure => "directory",
    owner  => "0",
    group  => "0",
    mode   => "0755",
    before => File["${rackdir_real}/config.ru"],
  }

  file { "${rackdir_real}/config.ru":
    ensure  => file,
    owner   => "puppet",
    group   => "puppet",
    mode    => "0644",
    content => template("puppet/rack_config.ru"),
    before  => Apache::Config["puppet_master_${identifier_real}_${port}.conf"],
  }

  file { [ "${confdir_real}",
           "${confdir_real}/manifests",
           "${confdir_real}/modules", ]:
    ensure => directory,
    owner  => "0",
    group  => "0",
    mode   => "0755",
    before => Apache::Config["puppet_master_${identifier_real}_${port}.conf"],
  }

  # JJM This may need to be a file fragment implementation
  file { "${confdir_real}/puppet.conf":
    ensure  => file,
    owner   => "0",
    group   => "0",
    mode    => "0644",
    content => $conf_contents_real,
    before  => Apache::Config["puppet_master_${identifier_real}_${port}.conf"],
  }

  file { "${confdir_real}/autosign.conf":
    ensure  => file,
    owner   => "0",
    group   => "0",
    mode    => "0644",
    content => "# Managed by Puppet\n${autosign_string}\n",
    before  => Apache::Config["puppet_master_${identifier_real}_${port}.conf"],
  }

  if $terminate_ssl_real {
    apache::config { "puppet_master_${identifier_real}_${port}.conf":
      content => template("puppet/puppet_master_XXXX.conf"),
    }
  } else {
    apache::config { "puppet_master_${identifier_real}_${port}.conf":
      content => template("puppet/puppet_worker_XXXX.conf"),
    }
  }

}
# EOF

