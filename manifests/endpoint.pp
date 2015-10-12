# == Define: icinga2::endpoint
#
# Defines an icinga2 endpoint
#
define icinga2::endpoint (
  $host = undef,
  $port = undef,
  $repository = false,
) {

  if $repository {
    $target = "/etc/icinga2/repository.d/endpoints/${name}.conf"
  } else {
    $target = '/etc/icinga2/zones.conf'
  }

  if ! defined(Icinga2::Config[$target]) {
    icinga2::config { $target: }
  }

  concat::fragment { "endpoint-${name}":
    target  => $target,
    content => template('icinga2/endpoint.erb'),
    order   => '10',
  }

}
