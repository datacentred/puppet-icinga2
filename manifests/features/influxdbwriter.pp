# == Class: icinga2::features::influxdbwriter
#
# Enable icinga2 influxdbwriters
#
class icinga2::features::influxdbwriter (
  $host_template,
  $service_template,
  $host = undef,
  $port = undef,
  $database = undef,
  $username = undef,
  $password = undef,
  $ssl_enable = false,
  $ssl_ca_cert = undef,
  $ssl_cert = undef,
  $ssl_key = undef,
  $enable_send_thresholds = false,
  $enable_send_metadata = false,
  $flush_interval = undef,
  $flush_threshold = undef,
) {

  icinga2::feature { 'influxdbwriter':
    content => template('icinga2/influxdbwriter.conf.erb'),
  }

  # Ensure repos and packages are installed before enabling, and notify
  # the service of changes
  Class['::icinga2::install'] ->
  Class['::icinga2::features::influxdbwriter'] ~>
  Class['::icinga2::service']

}
