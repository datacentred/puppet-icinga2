# == Define: icinga2::endpoint
#
# Defines an icinga2 endpoint
#
define icinga2::endpoint (
  $host = undef,
  $port = undef,
) {

  include ::icinga2::zones

  concat::fragment { "endpoint-${name}":
    target  => '/etc/icinga2/zones.conf',
    content => template('icinga2/endpoint.erb'),
    order   => '10',
  }

}
