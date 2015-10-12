# == Class: icinga2::config
#
# Define icinga2 config files
#
define icinga2::config {

  concat { $name:
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  concat::fragment { "${name} header":
    target  => $name,
    content => template('icinga2/header.erb'),
    order   => '0',
  }

  # Ensure packages are installed first and notify the service of changes
  Class['::icinga2::install'] ->
  Icinga2::Config[$name] ~>
  Class['::icinga2::service']

}
