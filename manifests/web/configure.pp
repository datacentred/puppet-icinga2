# == Class: icinga2::web::configure
#
# Configures icinga web.  Note that you must define apache::mpm_module globally
# in your hiera configuration for it to provision correctly
#
class icinga2::web::configure {

  include ::apache
  include ::apache::mod::php
  include ::apache::mod::rewrite

  $timezone = $::icinga2::web::timezone
  $aliases = $::icinga2::web::aliases

  # Fix up permissions so icingaweb2 works
  file { '/etc/icingaweb2/modules':
    ensure => directory,
    owner  => 'root',
    group  => 'icingaweb2',
    mode   => '2770',
  }

  # Allow apache to run as the icingaweb2 group
  exec { "usermod -a -G icingaweb2 ${::icinga2::www_user}":
    unless => "id ${::icinga2::www_user} | grep icingaweb2",
  } ->

  # Execute this before the VirtualHost is created as this will implicitly
  # restart apache and pick up the changes
  augeas { 'php.ini':
    context => $::icinga2::web_php_ini,
    changes => "set Date/date.timezone ${timezone}",
  } ->

  apache::vhost { $::fqdn:
    docroot       => '/usr/share/icingaweb2/public',
    port          => 80,
    serveraliases => $aliases,
    directories   => {
      'path'           => '/usr/share/icingaweb2/public',
      'options'        => [
        'SymLinksIfOwnerMatch',
      ],
      'allow_override' => [
        'None',
      ],
      'setenv'         => [
        'ICINGAWEB_CONFIGDIR /etc/icingaweb2',
      ],
      'rewrites'       => [
        {
          'rewrite_base' => '/',
          'rewrite_cond' => [
            '%{REQUEST_FILENAME} -s [OR]',
            '%{REQUEST_FILENAME} -l [OR]',
            '%{REQUEST_FILENAME} -d',
          ],
          'rewrite_rule' => [
            '^.*$ - [NC,L]',
            '^.*$ index.php [NC,L]',
          ],
        },
      ],
    },
  }

  # Ensure apache and the web user is installed before modifying the groups
  Class['::apache'] -> Class['icinga2::web::configure']

  # Fixes a idempotency race condition whereby apache is installed and
  # purges conf.d before the icingaweb2 package installs its configuration
  Class['::icinga2::web::install'] -> Class['::apache']
}
