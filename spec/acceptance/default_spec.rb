require 'spec_helper_acceptance'

describe 'icinga2' do

  # Create a CA and certificate for the api
  shell('puppet cert generate $(facter fqdn)')
  # Add in an MPM module for mod_php
  shell('echo "apache::mpm_module: \'prefork\'" >> /var/lib/hiera/common.yaml')
  # Setup networking so `hostname -f` works as expected
  shell('echo -e "127.0.0.1 localhost\n$(facter ipaddress) $(facter fqdn) $(facter hostname)" > /etc/hosts')
  # All in one configuration
  pp = <<-EOS
    Exec { path => '/bin:/usr/bin:/sbin:/usr/sbin' }

    include ::icinga2
    include ::icinga2::web
    include ::icinga2::features::api
    include ::icinga2::features::checker
    include ::icinga2::features::command
    include ::icinga2::features::graphitewriter
    include ::icinga2::features::ido_mysql

    icinga2::object::endpoint { $::fqdn: }

    icinga2::object::zone { $::fqdn:
      endpoints => [ $::fqdn],
    }

    icinga2::object::template_host { 'generic-host':
      max_check_attempts => 3,
      check_interval     => '1m',
      retry_interval     => '30s',
      check_command      => 'hostalive',
    }

    icinga2::object::template_service { 'generic-service':
      max_check_attempts => 5,
      check_interval     => '1m',
      retry_interval     => '30s',
    }

    icinga2::object::host { $::fqdn:
      import        => 'generic-host',
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
        '"/bin/true"',
      ],
      arguments => {
        '-a' => '$fake_a$',
        '-b' => {
          'set_if' => '$fake_b$',
        },
      },
      vars      => {
        'fake_b' => false,
      }
    }

    icinga2::object::apply_service { 'fake2':
      import        => 'generic-service',
      check_command => 'fake',
      display_name  => 'overridden name',
      vars          => {
        'fake_a' => [ 'fake', 'fake2', 'fake3' ],
        'fake_b' => true,
      },
      zone          => $::fqdn,
      assign_where  => true,
    }

    icinga2::object::apply_service_for { 'ping':
      import        => 'generic-service',
      key           => 'interface',
      value         => 'attributes',
      hash          => 'host.vars.interfaces',
      check_command => 'ping',
      vars          => {
        'ping_address' => 'attributes.ipaddress',
      },
      zone          => $::fqdn,
      assign_where  => true,
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
