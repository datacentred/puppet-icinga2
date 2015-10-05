# == Class: icinga2::repo
#
# Installs the icinga repository
#
class icinga2::repo {

  assert_private()

  if $icinga2::repo_manage {

    include ::apt

    apt::source { 'icinga':
      location => 'http://packages.icinga.org/ubuntu',
      release  => "icinga-${::lsbdistcodename}",
      repos    => 'main',
      key      => {
        'id'     => 'F51A91A5EE001AA5D77D53C4C6E319C334410682',
        'source' => 'http://packages.icinga.org/icinga.key',
      },
    }

  }

}
