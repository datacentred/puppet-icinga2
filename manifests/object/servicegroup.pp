# == Define: icinga2::object::servicegroup
#
# Defines a service group object
#
define icinga2::object::servicegroup (
  $display_name,
  $groups = undef,
  $assign_where = undef,
) {

  $target = '/etc/icinga2/conf.d/groups.conf'

  if ! defined(Icinga2::Config[$target]) {
    icinga2::config { $target: }
  }

  concat::fragment { "icinga2::object::servicegroup ${title}":
    target  => $target,
    content => template('icinga2/object/servicegroup.conf.erb'),
    order   => '20',
  }

}
