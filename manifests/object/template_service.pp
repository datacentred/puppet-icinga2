# == Define: icinga2::object::template_service
#
# Allows definition of service templates
#
define icinga2::object::template_service (
  $max_check_attempts = undef,
  $check_interval = undef,
  $retry_interval = undef,
) {

  $target = '/etc/icinga2/conf.d/templates.conf'

  if !defined(Icinga2::Config[$target]) {
    icinga2::config { $target: }
  }

  concat::fragment { "icinga2::object::template_service ${title}":
    target  => $target,
    content => template('icinga2/object/template_service.conf.erb')
  }

}
