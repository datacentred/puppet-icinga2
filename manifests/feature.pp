# == Define: icinga2::feature
#
# Control whether a feature is enabled or not, optionally updating the
# configuration file
#
define icinga2::feature (
  $content = undef,
) {

  if $content {

    file { "/etc/icinga2/features-available/${name}.conf":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => $content,
    } ->

    File["/etc/icinga2/features-enabled/${name}.conf"]

  }

  file { "/etc/icinga2/features-enabled/${name}.conf":
    ensure => link,
    target => "/etc/icinga2/features-available/${name}.conf",
  }

}
