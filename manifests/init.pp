# == Class: selenium
#
# Sets a node up ready to deploy selenium/appium servers on
#
# === Parameters
#
# [*java_home*] the location of the java jdk to use
# [*android_home*] the location of the android sdk
# [*standalone_server*] the file location of the selenium standalone server
# [*chromedriver*] the location of the chromedriver to deploy
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
# [*appium_path*] The location where appium is expected to be installed
#
# === Authors
#
# Christopher Johnson - cjohn@ceh.ac.uk
#
class selenium (
  $java_home,
  $android_home              = undef,
  $standalone_server         = undef,
  $chromedriver              = undef,
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
  $appium_path               = '/usr/lib/node_modules/appium'
) {

  $udev_device_rules_location = '/etc/udev/rules.d/51-selenium.rules'
  $udev_reverse_tether_rules_location = '/etc/udev/rules.d/81-selenium.rules'

  $adb_location = "${android_home}/platform-tools/adb"

  $config_path  = '/etc/selenium'
  $selenium_dir = '/opt/selenium'
  $selenium_jar = "${selenium_dir}/server.jar"

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
    owner   => $user,
    group   => $group,
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
    }
  }

  if $chromedriver {
    file { '/usr/bin/chromedriver' :
      ensure => file,
      owner  => root,
      group  => root,
      mode   => '0755',
      source => $chromedriver,
    }
  }

}