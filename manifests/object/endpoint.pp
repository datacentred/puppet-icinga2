# == Define: icinga2::object::endpoint
#
# Defines an icinga2 endpoint
#
define icinga2::object::endpoint (
  $host = undef,
  $port = undef,
  $target = '/etc/icinga2/zones.conf',
) {

  if ! defined(Icinga2::Config[$target]) {
    icinga2::config { $target: }
  }

  concat::fragment { "icinga2::object::endpoint ${name}":
    target  => $target,
    content => template('icinga2/object/endpoint.conf.erb'),
    order   => '10',
  }

}
