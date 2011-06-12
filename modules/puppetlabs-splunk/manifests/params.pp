# Class: splunk::params
#
#   This class is a simple data store.  We are pulling some logic out of other
#   classes to make the code more clean.  This is a replacement for the future
#   Puppet Data Library and will be completely replaceable.
#
class splunk::params {
  $no_repo_provider = $operatingsystem ? {
    /(?i-mx:ubuntu|debian)/        => 'dpkg',
    /(?i-mx:centos|fedora|redhat)/ => 'rpm',
  }
  $repo_provider = $operatingsystem ? {
    /(?i-mx:ubuntu|debian)/        => 'apt',
    /(?i-mx:centos|fedora|redhat)/ => 'yum',
  }
  $pkg_file = $operatingsystem ? {
    /(?i-mx:ubuntu|debian)/ => $hardwaremodel ? {
      'x86_64' => 'splunk-4.1.7-95063-linux-2.6-amd64.deb',
      default  => 'splunk-4.1.7-95063-linux-2.6-intel.deb',
    },
    /(?i-mx:centos|fedora|redhat)/ => $hardwaremodel ? {
      'x86_64' => 'splunk-4.1.7-95063-linux-2.6-x86_64.rpm',
      default  => 'splunk-4.1.7-95063.i386.rpm',
    },
  }
}
