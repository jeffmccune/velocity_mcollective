# This file is centrally managed.
$0 = "master"
ARGV << "--rack"
ARGV << "--confdir" << "<%= confdir_real %>"
require 'puppet/application/master'
run Puppet::Application[:master].run
# EOF
