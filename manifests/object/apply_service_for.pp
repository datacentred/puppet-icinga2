# == Define: icinga2::object::apply_service_for
#
# Manages local and remote services
#
define icinga2::object::apply_service_for (
  $key,
  $value,
  $hash,
  $import = undef,
  $check_command = undef,
  $display_name = undef,
  $vars = undef,
  $zone = undef,
  $assign_where = undef,
  $target = '/etc/icinga2/conf.d/services.conf',
) {

  if ! defined(Icinga2::Config[$target]) {
    icinga2::config { $target: }
  }

  concat::fragment { "icinga2::object::apply_service_for ${title}":
    target  => $target,
    content => template('icinga2/object/apply_service_for.conf.erb'),
    order   => '10',
  }

}
