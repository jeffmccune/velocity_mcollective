splunk::index { 'dmesg':
    target => [ '/var/log/dmesg', '/var/log/messages' ],
    require => Class['splunk::package'],
}
