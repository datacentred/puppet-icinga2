# == Class: icinga2::features::command
#
# Enable the icinga2 command pipe
#
class icinga2::features::command {

  icinga2::feature { 'command':
    ensure => present,
  }

}
