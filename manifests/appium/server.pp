# == Define: selenium::appium::server
#
# Sets up an instance of the appium application to run as a service
#
define selenium::appium::server (
  $port               = 4723,
  $chromedriver_port  = 9515,
  $bootstrap_port     = 4724,
  $java_home          = $selenium::java_home,
  $android_home       = $selenium::android_home
) {
  if ! defined(Class['selenium::appium']) {
    fail('You must include the appium class in order to create an appium server')
  }


}