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
# [*headless_command*] The command to use to start the server headlessly
# [*service_enable*]   If the service for this server should be enabled
# [*service_ensure*]   The ensure value for the underlying service
# [*user*]             The user to run the service as
# [*group*]            which should run the appium service
# [*max_session*]      maximum amount of concurrent tests which can be run on this node
# [*custom_arguments*] to be appended to the executable if unhandled by this module
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
  $headless_command  = $selenium::headless_command,
  $service_enable    = true,
  $service_ensure    = true,
  $user              = $selenium::user,
  $group             = $selenium::group,
  $max_session       = 5,
  $custom_arguments  = [],
  $capabilities      = $selenium::capabilities
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
    'node' => [
      '-nodeConfig', $node_config,
      "-Dwebdriver.ie.driver=${selenium::iedriver_path}", 
      "-Dwebdriver.chrome.driver=${selenium::chromedriver_path}"
    ],
    'hub'  => ['-port', $port],
  }

  $command = concat([$selenium::java, '-jar', $selenium::selenium_jar, '-role', $role], $role_options)

  selenium::service { "selenium-${name}":
    command          => concat($command, $custom_arguments),
    subscribe        => File[$selenium::selenium_jar],
    user             => $user,
    group            => $group,
    service_ensure   => $service_ensure,
    service_enable   => $service_enable,
    headless         => $headless,
    headless_command => $headless_command,
  }
}
