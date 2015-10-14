# == Class: icinga2::object::service
#
# Manages local and remote services
#
define icinga2::object::service (
  $import = 'generic-service',
  $check_command = undef,
  $host_name = $::fqdn,
  $zone = $::fqdn,
  $repository = false,
) {

  if $repository {
    $target = "/etc/icinga2/repository.d/hosts/${host_name}/${title}.conf"
  } else {
    $target = '/etc/icinga2/conf.d/services.conf'
  }

  if ! defined(Icinga2::Config[$target]) {
    icinga2::config { $target: }
  }

  concat::fragment { "icinga2::object::service ${host_name} ${title}":
    target  => $target,
    content => template('icinga2/service.conf.erb'),
  }

}
