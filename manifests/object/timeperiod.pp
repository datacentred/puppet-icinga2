# == Define: icinga2::object::timeperiod
#
# Defines a time period for downtimes and notifications
#
define icinga2::object::timeperiod (
  $import = undef,
  $display_name = undef,
  $ranges = undef,
  $target = '/etc/icinga2/conf.d/timeperiods.conf',
) {

  if ! defined(Icinga2::Config[$target]) {
    icinga2::config { $target: }
  }

  concat::fragment { "icinga2::object::timeperiod ${title}":
    target  => $target,
    content => template('icinga2/object/timeperiod.conf.erb'),
    order   => '10',
  }

}
