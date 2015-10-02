# == Class: icinga2::features::command
#
# Enable the icinga2 command pipe
#
class icinga2::features::command (
  $path = undef,
) {

  icinga2::feature { 'command':
    content => template('icinga2/command.conf.erb'),
  }

  # Ensure repos and packages are installed before enabling, and notify
  # the service of changes
  Class['::icinga2::install'] ->
  Class['::icinga2::features::command'] ~>
  Class['::icinga2::service']

}
