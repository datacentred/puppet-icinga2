# == Class: icinga2::features::api
#
# Enables the icinga2 api
#
class icinga2::features::api (
  $cert_path = "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
  $key_path = "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
  $ca_path = '/var/lib/puppet/ssl/certs/ca.pem',
  $accept_commands = false,
) {

  # We are using puppet's CA infrastructure allow access to the certs and keys
  exec { 'icinga2::server::configure: usermod nagios':
    command => 'usermod -a -G puppet nagios',
    unless  => 'id nagios | grep puppet',
  }

  icinga2::feature { 'api':
    content => template('icinga2/api.conf.erb'),
  }

  # Ensure repos and packages are installed before enabling, and notify
  # the service of changes
  Class['::icinga2::install'] ->
  Class['::icinga2::features::api'] ~>
  Class['::icinga2::service']

}
