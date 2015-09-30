# == Define: icinga2::zone
#
# Defines an icinga2 zone
#
define icinga2::zone (
  $endpoints = [],
  $parent = undef,
) {

  include ::icinga2::zones

  concat::fragment { "zone-${name}":
    target  => '/etc/icinga2/zones.conf',
    content => template('icinga2/zone.erb'),
    order   => '20',
  }

}
