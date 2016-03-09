# == Define: icinga2::object::apiuser
#
# Defines an icinga2 apiuser
#
define icinga2::object::apiuser (
  $password = undef,
  $client_cn = undef,
  $permissions = [],
  $target = '/etc/icinga2/conf.d/api-users.conf',
) {

  if ! defined(Icinga2::Config[$target]) {
    icinga2::config { $target: }
  }

  concat::fragment { "icinga2::object::apiuser ${name}":
    target  =>  $target,
    content => template('icinga2/object/apiuser.conf.erb'),
    order   => '20',
  }

}
