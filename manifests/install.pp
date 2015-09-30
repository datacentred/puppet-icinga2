# == Class: icinga2::install
#
# Installs the icinga2 daemon
#
class icinga2::install {

  assert_private()

  $packages = [
    'icinga2',
    'nagios-plugins',
    'nagios-plugins-extra',
    'nagios-plugins-contrib',
    'nagios-plugins-openstack',
  ]

  ensure_packages($packages)

}
