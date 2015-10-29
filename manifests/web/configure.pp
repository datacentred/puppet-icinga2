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

}
