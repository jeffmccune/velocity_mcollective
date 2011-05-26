# TODO

## /etc/puppet/puppet.conf

Add ability to manage /etc/puppet/puppet.conf on the seed  This should be
modeled as a class parameter to the puppet::master::seed class.  It should
accept a string value for the entire contents coming from a third party module.

## Clean up params class.

Cody mentioned sub classing the params class to clean up a lot of the
validation code and consolidate it into one class.

