# == Class: selenium
#
# Sets a node up ready to deploy selenium/appium servers on
#
# === Parameters
#
# [*android_home*] the location of the android sdk
# [*standalone_server*] the file location of the selenium standalone server
# [*chromedriver*] the location of the chromedriver to deploy
# [*iedriver*] the location of the ie driver to deploy (windows only)
# [*hub_host*] the ip or hostname of the selenium grid hub
# [*hub_port*] the port which the hub is running on
# [*user*] the user selenium should run as
# [*group*] the group selenium should run as
# [*manage_user*] if the selenium user should be managed
# [*manage_group*] if the selenium group should be managed
# [*reverse_tether*] If reverse tethering should be enabled by default
# [*reverse_tether_netmask*] The default netmask to be used when reverse
#   tethering
# [*reverse_tether_dns_server*] The default dns server to be used when
#   reverse tethering
# [*reverse_tether_dns_backup*] The default backup dns server to be used when
#   reverse tethering
# [*headless_command*] The command to run by default when a service should be
#   run headlessly
#
# === Authors
#
# Christopher Johnson - cjohn@ceh.ac.uk
#
class selenium (
  $android_home              = undef,
  $standalone_server         = undef,
  $chromedriver              = undef,
  $iedriver                  = undef,
  $hub_host                  = $fqdn,
  $hub_port                  = 4444,
  $user                      = 'selenium',
  $group                     = 'selenium',
  $manage_user               = true,
  $manage_group              = true,
  $reverse_tether            = true,
  $reverse_tether_netmask    = '255.255.255.0',
  $reverse_tether_dns_server = '8.8.8.8',
  $reverse_tether_dns_backup = '8.8.4.4',
  $headless_command          = 'xvfb-run -a'
) {

  $udev_device_rules_location = '/etc/udev/rules.d/51-selenium.rules'
  $udev_reverse_tether_rules_location = '/etc/udev/rules.d/81-selenium.rules'

  $java = $::osfamily ? {
    windows => 'java',
    default => '/usr/bin/java',
  }

  $adb_location = "${android_home}/platform-tools/adb"

  $config_path  = $::osfamily ? {
    windows => 'c:/Program Files/selenium/conf',
    default => '/etc/selenium',
  }

  $selenium_dir = $::osfamily ? {
    Darwin  => "/Users/${user}/selenium",
    windows => 'c:/Program Files/selenium',
    default => '/opt/selenium',
  }

  $selenium_jar = "${selenium_dir}/server.jar"

  $appium_path = $::osfamily ? {
    Darwin  => '/usr/local/lib/node_modules/appium',
    windows => 'c:/Program Files/nodejs/node_modules/appium',
    default => '/usr/lib/node_modules/appium',
  }

  $node_executable = $::osfamily ? {
    Darwin  => '/usr/local/bin/node',
    windows => 'c:/Program Files/nodejs/node',
    default => '/usr/bin/node',
  }

  $chromedriver_path = $::osfamily ? {
    Darwin  => '/usr/local/bin/chromedriver',
    windows => "${selenium_dir}/chromedriver.exe",
    default => '/usr/bin/chromedriver',
  }

  $iedriver_path = "${selenium_dir}/IEDriverServer.exe"

  $capabilities = $::osfamily ? {
    Darwin  => [
      {browserName => 'safari',  maxInstances => 5}
    ],
    windows => [
      {browserName => 'chrome',            maxInstances => 5},
      {browserName => 'firefox',           maxInstances => 5},
      {browserName => 'internet explorer', maxInstances => 1}
    ],
    default => [
      {browserName => 'chrome',  maxInstances => 5},
      {browserName => 'firefox', maxInstances => 5}
    ],
  }

  if $manage_user {
    user { $user :
      ensure     => present,
      gid        => $group,
      managehome => true,
    }
  }

  if $manage_group {
    group { $group :
      ensure => present,
    }
  }

  # Create a location to put some node config files
  file { $config_path :
    ensure => directory,
    owner  => $user,
    group  => $group,
  }

  file { $selenium_dir :
    ensure => directory,
    owner  => $user,
    group  => $group,
  }

  if $standalone_server {
    file { $selenium_jar :
      ensure => file,
      source => $standalone_server,
      owner  => $user,
      group  => $group,
      mode   => '0755',
    }
  }

  if $chromedriver {
    file { $chromedriver_path :
      ensure => file,
      owner  => $user,
      group  => $group,
      mode   => '0755',
      source => $chromedriver,
    }
  }

  if $iedriver {
    file { $iedriver_path :
      ensure => file,
      owner  => $user,
      group  => $group,
      mode   => '0755',
      source => $iedriver,
    }
  }
}
