# == Define: icinga2::object::apply_notification
#
# Defines a notification
#
define icinga2::object::apply_notification (
  $object = undef,
  $command = undef,
  $states = [],
  $types = [],
  $period = undef,
  $users = [],
  $assign_where = undef,
) {

  $target = '/etc/icinga2/conf.d/notifications.conf'

  if !defined(Icinga2::Config[$target]) {
    icinga2::config { $target: }
  }

  concat::fragment { "icinga2::object::notification ${title}":
    target  => $target,
    content => template('icinga2/object/apply_notification.conf.erb')
  }

}
