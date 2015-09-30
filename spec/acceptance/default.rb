require 'spec_helper_acceptance'

describe 'icinga' do
  context 'full install' do
    it 'provisions with no errors' do
      pp = <<-EOS
        Exec { path => '/bin:/usr/bin:/sbin:/usr/sbin' }
        include ::icinga2
        include ::icinga2::web
        include ::icinga2::features::api
        include ::icinga2::features::command
        include ::icinga2::features::ido_mysql
      EOS
      # Check for clean provisioning and idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end
end
