# == Define: icinga2::object::checkcommand
#
# Defines a service check command
#
define icinga2::object::checkcommand (
  $command,
  $arguments = undef,
  $vars = undef,
) {

  $target = '/etc/icinga2/conf.d/checks.conf'

  if !defined(Icinga2::Config[$target]) {
    icinga2::config { $target: }
  }

  concat::fragment { "icinga2::object::checkcommand ${title}":
    target  => $target,
    content => template('icinga2/object/checkcommand.conf.erb')
  }

}
