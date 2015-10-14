# == Define: icinga2::object::zone
#
# Defines an icinga2 zone
#
define icinga2::object::zone (
  $endpoints = [],
  $parent = undef,
  $repository = false,
) {

  if $repository {
    $target = "/etc/icinga2/repository.d/zones/${name}.conf"
  } else {
    $target = '/etc/icinga2/zones.conf'
  }

  if ! defined(Icinga2::Config[$target]) {
    icinga2::config { $target: }
  }

  concat::fragment { "icinga2::object::zone ${name}":
    target  =>  $target,
    content => template('icinga2/zone.conf.erb'),
    order   => '20',
  }

}
