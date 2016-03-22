# == Class: icinga2::features::ido_mysql
#
# Configure and enable the IDO MySQL feature
#
class icinga2::features::ido_mysql (
  $host = 'localhost',
  $user = 'icinga',
  $password = 'icinga',
  $database = 'icinga',
) {

  include ::mysql::server

  mysql::db { $database:
    user     => $user,
    password => $password,
  } ~>

  package { 'icinga2-ido-mysql':
    ensure => present,
  } ~>

  exec { '::icinga2::ido_mysql: import schema':
    command     => "mysql -u${user} -p${password} ${database} < /usr/share/icinga2-ido-mysql/schema/mysql.sql",
    logoutput   => true,
    refreshonly => true,
  } ->

  icinga2::feature { 'ido-mysql':
    content => template('icinga2/ido-mysql.conf.erb'),
  }

  # Ensure repos and packages are installed before enabling, and notify
  # the service of changes
  Class['::icinga2::install'] ->
  Class['::icinga2::features::ido_mysql'] ~>
  Class['::icinga2::service']

}
