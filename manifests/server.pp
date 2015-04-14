# == Define: selenium::server
#
# Creates an instance of the selenium standalone server with a particular
# role (either hub or node)
#
# === Parameters
#
# [*role*]             Either hub or node, the role this server should run as
# [*hub_host*]         If role is node, the hub to use as a host
# [*hub_port*]         The port which the hub is running on
# [*port*]             which this selenium node/hub will run on
# [*host*]             The hostname of this machine as it should be registered to the hub
# [*headless*]         If this server should run headlessly (Linux only)
# [*service_enable*]   If the service for this server should be enabled
# [*service_ensure*]   The ensure value for the underlying service
# [*headless_command*] The command to use to start the server headlessly
# [*user*]             The user to run the service as
# [*group*]            which should run the appium service
# [*max_session*]      maximum amount of concurrent tests which can be run on this node
# [*capabilities*]     a list of selenium browser capabilities
#
# === Authors
#
# Christopher Johnson - cjohn@ceh.ac.uk
#
define selenium::server (
  $role,
  $hub_host          = $selenium::hub_host,
  $hub_port          = $selenium::hub_port,
  $port              = 5555,
  $host              = $fqdn,
  $headless          = false,
  $service_enable    = true,
  $service_ensure    = true,
  $headless_command  = 'xvfb-run',
  $user              = $selenium::user,
  $group             = $selenium::group,
  $max_session       = 5,
  $capabilities      = [
    {browserName => "chrome",  maxInstances => 5},
    {browserName => "firefox", maxInstances => 5}
  ]
) {
  if ! $selenium::standalone_server {
    fail('You must provide the selenium base class with a selenium standalone server jar file to run')
  }

  $node_config = "${selenium::config_path}/selenium-${name}.json"
  
  if $role == 'node' {
    file { $node_config :
      ensure  => file,
      owner   => $user,
      group   => $group,
      mode    => '0644',
      content => template('selenium/grid2-nodeconfig.erb'),
      notify  => Selenium::Service["selenium-${name}"],
    }
  }

  $role_options = $role ? {
    'node' => ['-nodeConfig', $node_config],
    'hub'  => ['-port', $port],
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
    group          => $group,
    service_ensure => $service_ensure,
    service_enable => $service_enable,
  }
}