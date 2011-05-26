class puppet::master::certificates {

  $vardir_real = $puppet::vardir_real
  $confdir_real = $puppet::confdir_real

  exec { "certificates":
    command => "puppet cert --confdir '${confdir_real}' --generate ${fqdn}",
    path    => "/usr/bin:/bin:/usr/sbin:/sbin",
    creates => "${vardir_real}/ssl/certs/${fqdn}.pem",
    require => File["${confdir_real}/puppet.conf"],
  } ~> Service <| title == "apache" |>

}
# EOF
