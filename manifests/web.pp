# == Class: icinga2::web
#
# Install icinga web UI
#
class icinga2::web (
  $timezone = 'UTC',
  $aliases = [],
) {

  include ::icinga2::web::install
  include ::icinga2::web::configure

  Class['::icinga2::repo'] ->
  Class['::icinga2::web::install'] ->
  Class['::icinga2::web::configure']

}
