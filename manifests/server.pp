# == Define: selenium::server
#
#
# === Parameters
#
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
    command   => concat($command, $role_options),
    subscribe => File[$jar],
  }
}