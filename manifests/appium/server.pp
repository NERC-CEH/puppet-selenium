# == Define: selenium::appium::server
#
# Sets up an instance of the appium application to run as a service
#
# === Parameters
# [*hub_host*]          The host which this appium instance should connect to
# [*hub_port*]          The port which the hub is running on
# [*port*]              which appium should run on
# [*chromedriver_port*] the port which the chromedriver will run on
# [*bootstrap_port*]    not too sure what this is (check the appium docs)
# [*android_home*]      location of your android sdk installation. Needed for driving android
# [*host*]              the hostname which the hub can contact this node on
# [*service_enable*]    the enabled value of the service (ubuntu only)
# [*service_ensure*]    the ensure value of the service (ubnutu only)
# [*user*]              which should run the appium service
# [*group*]             which should run the appium service
# [*headless*]          If this server should run headlessly (Linux only)
# [*headless_command*]  The command to use to start the server headlessly
# [*max_session*]       maximum amount of concurrent tests which can be run on this node
# [*capabilities*]      a list of selenium browser capabilities
#
# === Authors
#
# Christopher Johnson - cjohn@ceh.ac.uk
#
define selenium::appium::server (
  $hub_host           = $selenium::hub_host,
  $hub_port           = $selenium::hub_port,
  $port               = 4723,
  $chromedriver_port  = 9515,
  $bootstrap_port     = 4724,
  $android_home       = $selenium::android_home,
  $host               = $fqdn,
  $service_enable     = true,
  $service_ensure     = true,
  $user               = $selenium::user,
  $group              = $selenium::group,
  $headless           = false,
  $headless_command   = $selenium::headless_command,
  $max_session        = 1,
  $capabilities       = [
    {browserName => "Appium ${name}", maxInstances => 1}
  ]
) {
  if ! defined(Class['selenium::appium']) {
    fail('You must include the appium class in order to create an appium server')
  }

  # Create the appium node configuration
  $node_config    = "${selenium::config_path}/appium-${name}.json"
  $appium         = "${selenium::node_executable} ${selenium::appium_path}/bin/appium.js"
  
  file { $node_config :
    ensure  => file,
    owner   => $user,
    group   => $group,
    mode    => '0644',
    content => template('selenium/grid2-nodeconfig.erb'),
  }
  
  selenium::service { "appium-${name}":
    environment      => {
      'ANDROID_HOME' => $android_home,
    },
    command          => [
      $selenium::node_executable, $selenium::appium_executable,
      '--port',              $port,
      '--chromedriver-port', $chromedriver_port,
      '--bootstrap-port',    $bootstrap_port,
      '--nodeconfig',        $node_config,
      '--log-level',         'warn',
      '--log-no-colors'
    ],
    user             => $user,
    group            => $group,
    service_ensure   => $service_ensure,
    service_enable   => $service_enable,
    subscribe        => File[$node_config],
    headless         => $headless,
    headless_command => $headless_command,
  }
}