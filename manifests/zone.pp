# == Define: icinga2::zone
#
# Defines an icinga2 zone
#
define icinga2::zone (
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

  concat::fragment { "zone-${name}":
    target  =>  $target,
    content => template('icinga2/zone.erb'),
    order   => '20',
  }

}
