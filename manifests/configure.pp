# == Class: icinga2::configure
#
# Configure base icinga2
#
class icinga2::configure {

  $user = $::icinga2::user
  $group = $::icinga2::group
  $plugin_dir = $::icinga2::plugin_dir
  $manubulon_plugin_dir = $::icinga2::manubulon_plugin_dir
  $plugin_contrib_dir = $::icinga2::plugin_contrib_dir
  $constants = $::icinga2::constants

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { [
    '/etc/icinga2',
    '/etc/icinga2/conf.d',
    '/etc/icinga2/zones.d',
    '/etc/icinga2/scripts',
    '/etc/icinga2/features-enabled',
  ] :
    ensure  => directory,
    mode    => '0755',
    recurse => true,
    purge   => true,
    force   => true,
  }

  file { [
    '/etc/icinga2/pki',
    '/etc/icinga2/repository.d',
    '/etc/icinga2/features-available',
  ] :
    ensure => directory,
    mode   => '0755',
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
