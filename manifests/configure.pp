# == Class: icinga2::configure
#
# Configure base icinga2
#
class icinga2::configure {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { [
    '/etc/icinga2',
    '/etc/icinga2/conf.d',
    '/etc/icinga2/zones.d',
  ] :
    ensure  => directory,
    mode    => '0755',
    recurse => true,
    purge   => true,
  }

  file { '/etc/icinga2/init.conf':
    ensure  => file,
    content => template('icinga2/init.conf.erb'),
  }

  file { '/etc/icinga2/icinga2.conf':
    ensure  => file,
    content => template('icinga2/icinga2.conf.erb'),
  }

  file { '/etc/icinga2/constants.conf':
    ensure  => file,
    content => template('icinga2/constants.conf.erb'),
  }

}
