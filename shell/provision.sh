#! /bin/bash
#
set -u

# Clear the hosts file
: > /etc/hosts

name="$1"

hostname "${name}"
puppet resource host localhost.localdomain ensure=present ip=127.0.0.1 host_aliases=localhost
puppet resource host ${name}.vagrant.internal ensure=present ip=`facter ipaddress_eth1` host_aliases=${name}

