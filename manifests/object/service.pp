# == Define: icinga2::object::service
#
# Manages local and remote services
#
define icinga2::object::service (
  $check_command,
  $check_name = undef,
  $import = 'generic-service',
  $vars = {},
  $host_name = $::fqdn,
  $zone = $::fqdn,
  $repository = false,
) {

  if $check_name {
    $check_name_real = $check_name
  } else {
    $check_name_real = $check_command
  }

  if $repository {
    $target = "/etc/icinga2/repository.d/hosts/${host_name}/${check_name_real}.conf"
  } else {
    $target = '/etc/icinga2/conf.d/services.conf'
  }

  if ! defined(Icinga2::Config[$target]) {
    icinga2::config { $target: }
  }

  concat::fragment { "icinga2::object::service ${host_name} ${check_name_real}":
    target  => $target,
    content => template('icinga2/object/service.conf.erb'),
    order   => '10',
  }

}
