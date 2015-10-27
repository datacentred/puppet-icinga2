# == Define: icinga2::object::service
#
# Manages local and remote services
#
define icinga2::object::service (
  $check_name = undef,
  $import = undef,
  $check_command = undef,
  $vars = undef,
  $host_name = $::fqdn,
  $zone = $::fqdn,
  $repository = false,
) {

  if $repository {
    $target = "/etc/icinga2/repository.d/hosts/${host_name}/${check_name}.conf"
  } else {
    $target = '/etc/icinga2/conf.d/services.conf'
  }

  if ! defined(Icinga2::Config[$target]) {
    icinga2::config { $target: }
  }

  concat::fragment { "icinga2::object::service ${title}":
    target  => $target,
    content => template('icinga2/object/service.conf.erb'),
    order   => '10',
  }

}
