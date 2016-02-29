require 'spec_helper_acceptance'

describe 'icinga' do
  context 'full install' do
    it 'provisions with no errors' do
      # Create a CA and certificate for the api
      shell('puppet cert generate $(facter fqdn)')
      # Add in an MPM module for mod_php
      shell('echo "apache::mpm_module: \'prefork\'" > /var/lib/hiera/common.yaml')
      pp = <<-EOS
        Exec { path => '/bin:/usr/bin:/sbin:/usr/sbin' }

        include ::icinga2
        include ::icinga2::web
        include ::icinga2::features::api
        include ::icinga2::features::command
        include ::icinga2::features::ido_mysql

        icinga2::object::endpoint { $::fqdn: }

        icinga2::object::zone { $::fqdn:
          endpoints => [ $::fqdn ],
        }

        icinga2::object::host { $::fqdn:
          check_command => 'hostalive',
          address       => $::ipaddress,
          vars          => {
            'kernel'           => $::kernel,
            'interfaces["eth0"]' => {
              'ipaddress'  => $::ipaddress,
              'netmask'    => $::netmask,
            },
          },
        }

        icinga2::object::checkcommand { 'fake':
          command   => [
            '"sudo"',
            '"/usr/bin/true"',
          ],
          arguments => {
            '-a'    => '$fake_a$',
            '-b'    => {
              'set_if' => '$fake_b$',
            },
          },
          vars      => {
            'fake_b' => false,
          }
        }

        icinga2::object::service { 'fake':
          check_command => 'fake',
          vars          => {
            'fake_a' => 'fake',
            'fake_b' => true,
          },
        }

        icinga2::object::apply_service_for { 'ping':
          key           => 'interface',
          value         => 'attributes',
          hash          => 'host.vars.interfaces',
          check_command => 'ping',
          vars          => {
            'ping_address' => 'attributes.ipaddress',
          },
          assign_where  => 'true',
          ignore_where  => 'host.vars.kernel != "Linux"',
        }
      EOS
      # Check for clean provisioning and idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end
end
