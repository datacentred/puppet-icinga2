# == Class: icinga2::params
#
class icinga2::params {

  case $::osfamily {
    'Debian': {
      $plugins = [
        'nagios-plugins',
        'nagios-plugins-extra',
        'nagios-plugins-contrib',
        'nagios-plugins-openstack',
      ]
      $user = 'nagios'
    }
    'RedHat': {
      $plugins = [
        'nagios-plugins-all',
      ]
      $user = 'icinga'
    }
  }

}
