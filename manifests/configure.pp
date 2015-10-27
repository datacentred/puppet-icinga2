# == Class: icinga2::configure
#
# Configure base icinga2
#
class icinga2::configure {

  file { [
    '/etc/icinga2/conf.d',
    '/etc/icinga2/repository.d/endpoints',
    '/etc/icinga2/repository.d/zones',
    '/etc/icinga2/repository.d/hosts',
  ] :
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => true,
    purge   => true,
  }

}
