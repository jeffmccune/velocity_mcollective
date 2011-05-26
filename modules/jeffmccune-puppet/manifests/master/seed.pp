class puppet::master::seed($autosign_list = [ '*.puppetlabs.vm' ])
{
  # Things we need to model on a seed.
  # Central Puppet Master
  # Version Control working copy.

  $ca_worker_port = 18140

  # Certificate Authority Service.
  # The load balancer will route all certificate related requests
  # to this worker instance, consolidating certificate operations.
  puppet::master { "puppet_ssl":
    terminate_ssl => false,
    ca            => true,
    autosign      => $autosign_list,
    port          => $ca_worker_port,
    storeconfigs  => false,
    confdir       => "/etc/puppet",
  }

  # Export the main SSL certificate authority server to the load balancer
  @@puppet::member { "${fqdn}_ssl_dev":
    frontend    => "puppet_dev",
    loadfactor  => 10,
    url         => "http://${fqdn}:${ca_worker_port}",
    ca          => true,
    hot_standby => false,
  }
  @@puppet::member { "${fqdn}_ssl_test":
    frontend    => "puppet_test",
    loadfactor  => 10,
    url         => "http://${fqdn}:${ca_worker_port}",
    ca          => true,
    hot_standby => false,
  }
  @@puppet::member { "${fqdn}_ssl_prod":
    frontend    => "puppet_prod",
    loadfactor  => 10,
    url         => "http://${fqdn}:${ca_worker_port}",
    ca          => true,
    hot_standby => false,
  }
  puppet::master { "seed_cluster":
    terminate_ssl => true,
    ca            => true,
    autosign      => $autosign_list,
    port          => "8140",
    storeconfigs  => true,
    dbadapter     => "sqlite3",
    confdir       => "/etc/puppet_cluster",
  }

}
#
