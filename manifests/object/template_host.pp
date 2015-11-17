# == Define: icinga2::object::template_host
#
# Allows definition of host templates
#
define icinga2::object::template_host (
  $max_check_attempts = undef,
  $check_interval = undef,
  $retry_interval = undef,
  $check_command = undef,
  $target = '/etc/icinga2/conf.d/templates.conf',
) {

  if !defined(Icinga2::Config[$target]) {
    icinga2::config { $target: }
  }

  concat::fragment { "icinga2::object::template_host ${title}":
    target  => $target,
    content => template('icinga2/object/template_host.conf.erb')
  }

}
