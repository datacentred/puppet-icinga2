# == Class: icinga2::features::ido_mysql
#
# Configure and enable the IDO MySQL feature
#
class icinga2::features::ido_mysql (
  $database = 'icinga',
  $username = 'icinga',
  $password = 'icinga',
) {

  include ::mysql::server

  Class['::icinga2::repo'] ->

  package { 'icinga2-ido-mysql':
    ensure => present,
  } ->

  mysql::db { $database:
    user     => $username,
    password => $password,
  } ~>

  exec { '::icinga2::ido: import schema':
    command     => "mysql ${db_name} < /usr/share/icinga2-ido-mysql/schema/mysql.sql",
    logoutput   => true,
    refreshonly => true,
  } ->

  file { '/etc/icinga2/features-available/ido-mysql.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('icinga2/ido-mysql.conf.erb'),
  } ->

  icinga2::feature { 'ido-mysql':
    ensure => present,
  }

  # Restart the service on an update of the configuration file
  File['/etc/icinga2/features-available/ido-mysql.conf'] ~> Class['::icinga2::service']

}
