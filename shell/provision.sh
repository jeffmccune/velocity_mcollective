#! /bin/bash
#
set -u

# Clear the hosts file
: > /etc/hosts

name="$1"

# Get the Mac's IP address
router="$(netstat -nr | awk '$1 ~ /0.0.0.0/ { print $2 }')"
router_1="${router%.*}.1"

ip_eth0=$(facter ipaddress_eth0)
ip_eth1=$(facter ipaddress_eth1)
ip=${ip_eth1:-${ip_eth0}}

# Manage resolv.conf for Fusion and dnsmasq on the Mac OS X host
cat <<EOFRESOLV>/etc/resolv.conf
# Managed by /vagrant/shell/provision.sh
domain vagrant.internal
search vagrant.internal internal
nameserver ${router_1}
EOFRESOLV

hostname "${name}"
puppet resource host localhost.localdomain ensure=present ip=127.0.0.1 host_aliases=localhost
puppet resource host ${name}.vagrant.internal ensure=present ip=$ip host_aliases=${name}
puppet resource host hypervisor.vagrant.internal ensure=present ip=$router_1 host_aliases=www

