# == Define: icinga2::object::usergroup
#
# Defines a user group
#
define icinga2::object::usergroup (
  $display_name,
  $target = '/etc/icinga2/conf.d/users.conf',
) {

  if ! defined(Icinga2::Config[$target]) {
    icinga2::config { $target: }
  }

  concat::fragment { "icinga2::object::usergroup ${title}":
    target  => $target,
    content => template('icinga2/object/usergroup.conf.erb'),
    order   => '20',
  }

}
