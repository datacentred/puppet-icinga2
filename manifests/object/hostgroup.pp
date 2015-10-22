# == Define: icinga2::object::hostgroup
#
# Defines a hostgroup object
#
define icinga2::object::hostgroup (
  $display_name,
  $groups = undef,
  $assign_where = undef,
) {

  $target = '/etc/icinga2/conf.d/groups.conf'

  if ! defined(Icinga2::Config[$target]) {
    icinga2::config { $target: }
  }

  concat::fragment { "icinga2::object::hostgroup ${title}":
    target  => $target,
    content => template('icinga2/object/hostgroup.conf.erb'),
    order   => '10',
  }

}
