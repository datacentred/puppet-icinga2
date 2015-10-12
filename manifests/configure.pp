# == Class: icinga2::configure
#
# Configure base icinga2
#
class icinga2::configure {

  file { [
    '/etc/icinga2/repository.d/endpoints',
    '/etc/ibinga2/repository.d/zones',
    '/etc/icinga2/repository.d/hosts',
  ] :
    owner => 'icinga',
    group => 'icinga',
    mode  => '0750',
  }

}
