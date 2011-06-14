# Name Resolution #

Fusion relies on my custom dnsmasq configuration on the Mac OS X host.  DHCP
will still be used, but the lease time is long enough to make this a non issue.

Just make sure stomp resolves to the puppet100 host and everything should be
fine.

# Steps when using Fusion for the demo #

 * Boot from base\_box snapshot
 * ssh in as root
 * run ~/mount\_vagrant
 * run /vagrant/shell/puppet100
 * run /vagrant/bin/provision
 * run /vagrant/bin/demo1

At this point MCollective and ActiveMQ will be fully up and running.
