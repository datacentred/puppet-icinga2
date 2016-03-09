require 'spec_helper_acceptance'

describe 'icinga2' do

  # Create a CA and certificate for the api
  shell('puppet cert generate $(facter fqdn)')
  # Add in an MPM module for mod_php
  shell('echo "apache::mpm_module: \'prefork\'" > /var/lib/hiera/common.yaml')
  # All in one configuration
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

    icinga2::object::apiuser { 'alice':
      password    => 'abc123',
      client_cn   => $::fqdn,
      permissions => [ '*' ],
    }
  EOS

  context 'install and configure' do
    it 'installs cleanly' do
      apply_manifest(pp, :catch_failures => true)
    end
    it 'is idempotent' do
      apply_manifest(pp, :catch_changes => true)
    end
  end

  context 'connectivity' do
    it 'allows basic api queries' do
      shell('curl --insecure --user alice:abc123 https://localhost:5665/v1/status')
    end
    it 'allows secure api queries' do
      shell('curl --cacert /var/lib/puppet/ssl/certs/ca.pem --cert /var/lib/puppet/ssl/certs/$(facter fqdn).pem --key /var/lib/puppet/ssl/private_keys/$(facter fqdn).pem https://$(facter fqdn):5665/v1/status')
    end
  end

end
