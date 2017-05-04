# == Class: icinga2::install
#
# Installs the icinga2 daemon
#
class icinga2::install {

  assert_private()

  $packages = [
    'icinga2',
  ]

  ensure_packages($packages, { ensure => $::icinga2::ensure })

  ensure_packages($::icinga2::plugins)
}
