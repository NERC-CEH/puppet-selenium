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
  $java_home          = $selenium::java_home,
  $android_home       = $selenium::android_home,
  $host               = $fqdn,
  $service_enable     = true,
  $service_ensure     = true
) {
  if ! defined(Class['selenium::appium']) {
    fail('You must include the appium class in order to create an appium server')
  }

  # Create the appium node configuration
  $node_config = "${selenium::config_path}/appium-${name}.json"
  $wrapper_script = "/opt/selenium/appium-${name}-startup.sh"
  $service_name = "appium-${name}"
  $appium = "${selenium::appium_path}/bin/appium.js"
  $user = $selenium::appium::user
  
  file { $node_config :
    ensure  => file,
    owner   => $selenium::appium::user,
    group   => $selenium::appium::group,
    mode    => '0644',
    content => template('selenium/appium-nodeconfig.erb'),
    notify  => Service[$service_name],
  }

  file { $wrapper_script :
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template('selenium/appium-startup.erb'),
    notify  => Service[$service_name],
  }

  file { "/etc/init.d/${service_name}" :
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template('selenium/init-service.erb'),
    notify  => Service[$service_name],
  }

  service { $service_name :
    ensure  => $service_ensure,
    enable  => $service_enable,
    require => [
      User[$selenium::appium::user],
      Package['appium'],
    ],
  }
}