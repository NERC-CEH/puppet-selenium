# == Define: selenium::appium::server
#
# Sets up an instance of the appium application to run as a service
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
  $user               = $selenium::appium::user,
  $group              = $selenium::appium::group
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
    content => template('selenium/appium-nodeconfig.erb'),
  }
  
  selenium::service { "appium-${name}":
    environment => {
      'ANDROID_HOME': $android_home
    },
    command   => [
      $selenium::node_executable, $selenium::appium_executable,
      '--port',              $port,
      '--chromedriver-port', $chromedriver_port,
      '--bootstrap-port',    $bootstrap_port,
      '--nodeconfig',        $node_config,
      '--log-level',         'warn',
      '--log-no-colors'
    ],
    subscribe => File[$node_config],
  }
}