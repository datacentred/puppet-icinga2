# == Class: icinga2::web::install
#
# Installs the icingaweb2 UI
#
class icinga2::web::install {

  $packages = [
    'icingaweb2',
  ]

  ensure_packages($packages)

  ensure_packages($::icinga2::webdeps)

}
