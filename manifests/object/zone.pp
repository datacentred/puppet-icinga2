# == Define: icinga2::object::zone
#
# Defines an icinga2 zone
#
define icinga2::object::zone (
  $endpoints = undef,
  $parent = undef,
  $global = undef,
  $target = '/etc/icinga2/zones.conf',
) {

  if ! defined(Icinga2::Config[$target]) {
    icinga2::config { $target: }
  }

  concat::fragment { "icinga2::object::zone ${name}":
    target  =>  $target,
    content => template('icinga2/object/zone.conf.erb'),
    order   => '20',
  }

}
