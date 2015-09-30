# == Define: icinga2::feature
#
# Control whether a feature is enabled or not
#
define icinga2::feature (
  $ensure = 'present',
) {

  if $ensure == 'present' {

    file { "/etc/icinga2/features-enabled/${name}.conf":
      ensure => link,
      target => "/etc/icinga2/features-available/${name}.conf",
    } ~>

    Class['::icinga2::service']

  } else {

    file { "/etc/icinga2/features-enabled/${name}.conf":
      ensure => 'absent',
    } ~>

    Class['::icinga2::service']

  }
}
