# == Class: icinga2::features::graphitewriter
#
# Enable icinga2 graphitewriters
#
class icinga2::features::graphitewriter (
  $host = undef,
  $port = undef,
  $host_name_template = undef,
  $service_name_template = undef,
  $enable_send_thresholds = undef,
  $enable_send_metadata = undef,
) {

  icinga2::feature { 'graphitewriter':
    content => template('icinga2/graphitewriter.conf.erb'),
  }

  # Ensure repos and packages are installed before enabling, and notify
  # the service of changes
  Class['::icinga2::install'] ->
  Class['::icinga2::features::graphitewriter'] ~>
  Class['::icinga2::service']

}
