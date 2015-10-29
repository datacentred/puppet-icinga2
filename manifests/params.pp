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
      $web_package_deps = [
        'php5-gd',
        'php5-imagick',
        'php5-intl',
        'php5-ldap',
      ]
      $web_php_ini = '/files/etc/php5/apache2/php.ini'
      $user = 'nagios'
    }
    'RedHat': {
      $plugins = [
        'nagios-plugins-all',
      ]
      $web_package_deps = [
        'php-gd',
        'php-intl',
        'php-ldap',
        'php-pecl-imagick',
      ]
      $web_php_ini = undef
      $user = 'icinga'
    }
  }

}
