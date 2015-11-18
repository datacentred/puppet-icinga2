# == Class: icinga2::features::checker
#
# Enable the icinga2 checker
#
class icinga2::features::checker {

  icinga2::feature { 'checker':
    content => template('icinga2/checker.conf.erb'),
  }

  # Ensure repos and packages are installed before enabling, and notify
  # the service of changes
  Class['::icinga2::install'] ->
  Class['::icinga2::features::checker'] ~>
  Class['::icinga2::service']

}
