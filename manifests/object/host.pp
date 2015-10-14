# == Define: icinga2::object::host
#
# Defines a host configuration
#
define icinga2::object::host (
  $display_name = $::fqdn,
  $address = $::ipaddress,
  $vars = {
    'architecture' => $::architecture,
    'lsbdistcodename' => $::lsbdistcodename,
    'operatingsystem' => $::operatingsystem,
    'os' => $::kernel,
  },
  $parent_fqdn = $::domain,
  $repository = false,
) {

  if $repository {
    $target = "/etc/icinga2/repository.d/hosts/${title}.conf"
  } else {
    $target = '/etc/icinga2/conf.d/hosts.conf'
  }

  if ! defined(Icinga2::Config[$target]) {
    icinga2::config { $target: }
  }

  concat::fragment { "icinga2::object::host ${title}":
    target  => $target,
    content => template('icinga2/hosts.conf.erb'),
  }

}
