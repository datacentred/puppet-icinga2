# == Define: icinga2::object::user
#
# Defines a user
#
define icinga2::object::user (
  $display_name = undef,
  $groups = undef,
  $email = undef,
  $pager = undef,
  $states = undef,
  $types = undef,
) {

  $target = '/etc/icinga2/conf.d/users.conf'

  if ! defined(Icinga2::Config[$target]) {
    icinga2::config { $target: }
  }

  concat::fragment { "icinga2::object::user ${title}":
    target  => $target,
    content => template('icinga2/object/user.conf.erb'),
    order   => '10',
  }

}
