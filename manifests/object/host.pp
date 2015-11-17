# == Define: icinga2::object::host
#
# Defines a host configuration
#
define icinga2::object::host (
  $import = undef,
  $display_name = undef,
  $check_command = undef,
  $address = undef,
  $vars = {},
  $icon_image = undef,
  $zone = undef,
  $target = '/etc/icinga2/conf.d/hosts.conf',
) {

  if ! defined(Icinga2::Config[$target]) {
    icinga2::config { $target: }
  }

  concat::fragment { "icinga2::object::host ${title}":
    target  => $target,
    content => template('icinga2/object/host.conf.erb'),
    order   => '10',
  }

}
