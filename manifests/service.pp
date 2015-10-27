# == Class: icinga2::service
#
# Ensures the icinga2 service is running
#
class icinga2::service {

  service { 'icinga2':
    ensure => running,
    enable => true,
  }

}
