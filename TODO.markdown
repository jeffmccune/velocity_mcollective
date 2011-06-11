# TODO List #

 * (SOLVED) Fix this error on the centos hosts:  (The solution is that facter
   is not in the default $LOAD\_PATH when installed into /usr/local/src/facter
   as it is on some vagrant base boxes.)

     base.rb:43:in `run' Sending registration message failed: No plugin
     facts_plugin defined

 * Need to make sure apt-get update happens after all sources are configured
   and before all packages are installed.
 * We need the nagios-plugins-basic on Lucid to get /usr/lib/nagios/plugins/check_file_age
 * mcollective server seems to be starting twice on Lucid while managed by Puppet.

