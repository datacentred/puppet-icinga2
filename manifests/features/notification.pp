# == Class: icinga2::features::notification
#
# Enable icinga2 notifications
#
class icinga2::features::notification {

  icinga2::feature { 'notification':
    content => template('icinga2/notification.conf.erb'),
  }

  # Ensure repos and packages are installed before enabling, and notify
  # the service of changes
  Class['::icinga2::install'] ->
  Class['::icinga2::features::notification'] ~>
  Class['::icinga2::service']

}
