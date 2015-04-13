# == Define: selenium::server
#
# Creates an instance of the selenium standalone server with a particular
# role (either hub or node)
#
# === Parameters
#
# [*role*]             Either hub or node, the role this server should run as
# [*hub_host*]         If role is node, the hub to use as a host
# [*host*]             The hostname of this machine as it should be registered to the hub
# [*headless*]         If this server should run headlessly (Linux only)
# [*service_enable*]   If the service for this server should be enabled
# [*service_ensure*]   The ensure value for the underlying service
# [*headless_command*] The command to use to start the server headlessly
# [*user*]             The user to run the service as
#
# === Authors
#
# Christopher Johnson - cjohn@ceh.ac.uk
#
define selenium::server (
  $role,
  $hub_host          = $selenium::hub_host,
  $host              = $fqdn,
  $headless          = false,
  $service_enable    = true,
  $service_ensure    = true,
  $headless_command  = 'xvfb-run',
  $user              = $selenium::user
) {
  if ! $selenium::standalone_server {
    fail('You must provide the selenium base class with a selenium standalone server jar file to run')
  }

  $role_options = $role ? {
    'node' => ['-hubHost', $hub_host, '-host', $host],
    'hub'  => [],
  }

  $java = $headless ? {
    true    => [$headless_command, $selenium::java],
    default => [$selenium::java],
  }

  $command = concat($java, ['-jar', $selenium::selenium_jar, '-role', $role])

  selenium::service { "selenium-${name}":
    command        => concat($command, $role_options),
    subscribe      => File[$selenium::selenium_jar],
    user           => $user,
    service_ensure => $service_ensure,
    service_enable => $service_enable,
  }
}