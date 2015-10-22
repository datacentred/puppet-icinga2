# == Define: icinga2::object::notificationcommand
#
# Defines a notification command
#
define icinga2::object::notificationcommand (
  $import = undef,
  $command = undef,
  $env = {},
) {

  $target = '/etc/icinga2/conf.d/notifications.conf'

  if !defined(Icinga2::Config[$target]) {
    icinga2::config { $target: }
  }

  concat::fragment { "icinga2::object::notificationcommand ${title}":
    target  => $target,
    content => template('icinga2/object/notificationcommand.conf.erb')
  }

}
