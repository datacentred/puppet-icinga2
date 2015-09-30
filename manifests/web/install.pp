# == Class: icinga2::web::install
#
# Installs the icingaweb2 UI
#
class icinga2::web::install {

  $packages = [
    'icingaweb2',
    'php5-gd',
    'php5-imagick',
    'php5-intl',
    'php5-ldap',
  ]

  ensure_packages($packages)

}
