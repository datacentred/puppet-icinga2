# == Class: icinga2::features::api
#
# Enables the icinga2 api
#
class icinga2::features::api (
  $cert = "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
  $key = "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
  $ca = '/var/lib/puppet/ssl/certs/ca.pem',
  $accept_commands = false,
) {

  # We are using puppet's CA infrastructure allow access to the certs and keys
  exec { 'icinga2::server::configure: usermod nagios':
    command => 'usermod -a -G puppet nagios',
    unless  => 'id nagios | grep puppet',
  } ->

  file { '/etc/icinga2/features-available/api.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('icinga2/api.conf.erb'),
  } ->

  icinga2::feature { 'api':
    ensure => present,
  }

  # Restart the service on an update of the configuration file
  File['/etc/icinga2/features-available/api.conf'] ~> Class['::icinga2::service']

}
