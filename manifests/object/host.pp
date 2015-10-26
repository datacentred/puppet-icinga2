# == Define: icinga2::object::host
#
# Defines a host configuration
#
define icinga2::object::host (
  $import = undef,
  $check_command = undef,
  $address = $::ipaddress,
  $vars = {},
  $icon_image = undef,
  $repository = false,
) {

  if $repository {
    $target = "/etc/icinga2/repository.d/hosts/${title}.conf"

    file { "/etc/icinga2/repository.d/hosts/${title}":
      ensure  => directory,
      owner   => 'nagios',
      group   => 'nagios',
      mode    => '0750',
      recurse => true,
      purge   => true,
    }
  } else {
    $target = '/etc/icinga2/conf.d/hosts.conf'
  }

  if ! defined(Icinga2::Config[$target]) {
    icinga2::config { $target: }
  }

  concat::fragment { "icinga2::object::host ${title}":
    target  => $target,
    content => template('icinga2/object/host.conf.erb'),
    order   => '10',
  }

}
