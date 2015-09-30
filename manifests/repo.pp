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

    # The current icingaweb 2.0.0-rc1 has a few issues with LDAP so use
    # snapshots until it is GA'd
    apt::source { 'icinga-snapshots':
      location => 'http://packages.icinga.org/ubuntu',
      release  => "icinga-${::lsbdistcodename}-snapshots",
      repos    => 'main',
    }

    apt::pin { 'icinga2':
      packages => 'icinga2*',
      release  => "icinga-${::lsbdistcodename}",
      priority => 500,
    }

    apt::pin { 'icingaweb2':
      packages => 'icingaweb2*',
      release  => "icinga-${::lsbdistcodename}-snapshots",
      priority => 600,
    }

  }

}
