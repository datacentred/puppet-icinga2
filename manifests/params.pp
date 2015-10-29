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
      $webdeps = [
        'php5-gd',
        'php5-imagick',
        'php5-intl',
        'php5-ldap',
      ]
      $user = 'nagios'
    }
    'RedHat': {
      $plugins = [
        'nagios-plugins-all',
      ]
      $webdeps = [
        'php-gd',
        'php-intl',
        'php-ldap',
        'php-pecl-imagick',
      ]
      $user = 'icinga'
    }
  }

}
