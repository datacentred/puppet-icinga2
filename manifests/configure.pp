# == Class: icinga2::configure
#
# Configure base icinga2
#
class icinga2::configure {

  file { [
    '/etc/icinga2/repository.d/endpoints',
    '/etc/icinga2/repository.d/zones',
    '/etc/icinga2/repository.d/hosts',
  ] :
    ensure  => directory,
    owner   => 'nagios',
    group   => 'nagios',
    mode    => '0750',
    recurse => true,
    purge   => true,
  }

}
