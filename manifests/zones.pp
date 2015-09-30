# == Class: icinga2::zones
#
# Define icinga2 zones
#
class icinga2::zones {

  concat { '/etc/icinga2/zones.conf':
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

}
