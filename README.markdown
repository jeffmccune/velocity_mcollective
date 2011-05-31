# Velocity 2010 #

Jeff McCune <jeff@puppetlabs.com>

 * [Asynchronous Real-time Monitoring with MCollective](http://velocityconf.com/velocity2011/public/schedule/detail/17848)

# Abstract #

Jeff McCune (Puppet Labs)
1:00pm Wednesday, 06/15/2011
Operations Ballroom ABCD

MCollective is a management framework that provides asynchronous remote
procedure calls across collections of systems. MCollective is capable of
managing systems, collecting performance and inventory data, and integrating
with configuration management tools and monitoring frameworks. It is an ideal
tool for large scale and simple orchestration and deployment of cloud systems.

Developers and System Administrators are empowered to address systems using
meta-data about the system instead of requiring knowledge of each system’s
hostname. Indeed the architecture of MCollective relies on systems being
addressed by their meta-data, collected from tools such as Facter and Ohai.
This makes it an ideal choice for managing systems in the cloud where hostnames
can be unpredictable and transient.

In addition to providing an orchestration and deployment solution, MCollective
is designed with real-time, asynchronous monitoring of service availability in
mind. Traditional monitoring solutions, such as Nagios, use synchronous polling
systems to check service state. As services are moved into the cloud,
developers can also bring systems up and down with ever increasing velocity. A
cloud monitoring system needs to be frequently reconfigured to monitor these
new systems. Traditional monitoring systems are either incapable of this level
of monitoring scalability or lack the agility needed to rapidly change
configuration. Using an asynchronous message bus and publish/subscribe
technologies, MCollective provides the ability to automatically start and stop
monitoring of a system as it comes up and down in the cloud.

This session will demonstrate the development and use of small Ruby agents to
obtain up to date inventory, status and performance information from a
collection of systems. Attendees will:

 * Get an introduction to MCollective
 * Understand why asynchronous communication is important when monitoring
 * Discover the benefits of addressing machines by meta-data
 * Learn how to write a monitoring agent for MCollective in Ruby
 * Understand how to re-mediate performance issues with MCollective and Puppet

# Quick Start #

TBD

# MCollective Notes #

With the default configuration provided by the Puppet Modules and this Vagrant
project, try out of the following MCollective actions.

## List Agents (RPC) ##

This command lists parseable output:

    sudo mco rpc rpcutil agent_inventory

## List Agents (Inventory) ##

This command lists human readable output and facts / agents:

    sudo mco inventory puppet10

## Collective Status ##

To obtain statistics for the collective: [More
Information](http://docs.puppetlabs.com/mcollective/reference/basic/daemon.html)

    [vagrant@puppet10 ~]$ sudo mco controller stats
    Determining the amount of hosts matching filter for 2 seconds .... 2
    
      puppet10> total=12, replies=7, valid=12, invalid=0, filtered=0, passed=12
         www21> total=12, replies=7, valid=12, invalid=0, filtered=0, passed=12
    
    Finished processing 2 / 2 hosts in 62.34 ms

## Reload all agents ##

    [vagrant@puppet10 ~]$ sudo mco controller reload_agents
    Determining the amount of hosts matching filter for 2 seconds .... 2
    
                                    puppet10> reloaded all agents
                                       www21> reloaded all agents
    
    Finished processing 2 / 2 hosts in 195.10 ms

## List a process ##

Note, this requires the sys/proctable gem.

    sudo mco rpc --agent process --action list

## Nagios Check ##

    sudo mco nrpe check_puppet_run

Note, if you get an error along the lines of "could not find command" then make
sure the nrpe plugin is using the correct nrpe.d directory.  This defaults to
/etc/nrpe.d on EL systems and /etc/nagios/nrpe.d on other systems.
