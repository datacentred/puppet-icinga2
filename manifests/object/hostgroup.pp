# == Define: icinga2::object::hostgroup
#
# Defines a hostgroup object
#
define icinga2::object::hostgroup (
  $display_name,
  $groups = undef,
  $assign_where = undef,
) {

  if ! defined(Icinga2::Config['/etc/icinga2/conf.d/groups.conf']) {
    icinga2::config { '/etc/icinga2/conf.d/groups.conf': }
  }

  concat::fragment { "icinga2::object::hostgroup ${title}":
    target  => '/etc/icinga2/conf.d/groups.conf',
    content => template('icinga2/hostgroup.conf.erb'),
  }

}
