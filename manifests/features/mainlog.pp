# == Class: icinga2::features::mainlog
#
# Enable the icinga2 mainlog
#
class icinga2::features::mainlog (
  $severity = 'information',
  $path = '/var/log/icinga2/icinga2.log',
) {

  icinga2::feature { 'mainlog':
    content => template('icinga2/mainlog.conf.erb'),
  }

  # Ensure repos and packages are installed before enabling, and notify
  # the service of changes
  Class['::icinga2::install'] ->
  Class['::icinga2::features::mainlog'] ~>
  Class['::icinga2::service']

}
