class puppet::master::worker {

  $port = 18140

  puppet::master { "worker_prod":
    terminate_ssl     => false,
    ca                => false,
    storeconfigs      => false,
    thin_storeconfigs => false,
    port              => $port,
    confdir           => "/etc/puppet_prod",
  }

  # This exports the load balancer member resource for the load balancer.
  @@puppet::member { "${fqdn}_prod":
    frontend    => "puppet_prod",
    ca          => false,
    loadfactor  => 10,
    url         => "http://${fqdn}:${port}",
    hot_standby => false,
  }

}
#

