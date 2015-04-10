# == Class: selenium
#
# Sets a node up ready to deploy selenium/appium servers on
#
# === Parameters
#
# [*java_home*] the location of the java jdk to use
# [*android_home*] the location of the android sdk
# [*user*] the user selenium should run as
# [*standalone_server*] the file location of the selenium standalone server
# [*hub_host*] the ip or hostname of the selenium grid hub
# [*hub_port*] the port which the hub is running on
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
# [*config_path*] The location where various selenium configuration will be saved
#
# === Authors
#
# Christopher Johnson - cjohn@ceh.ac.uk
#
class selenium (
  $java_home,
  $android_home,
  $standalone_server         = undef,
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
  $config_path               = '/etc/selenium',
  $appium_path               = '/usr/lib/node_modules/appium'
) {

  $adb_location = "${android_home}/platform-tools/adb"
  $udev_device_rules_location = '/etc/udev/rules.d/51-selenium.rules'
  $udev_reverse_tether_rules_location = '/etc/udev/rules.d/81-selenium.rules'
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

  concat { $udev_device_rules_location :
    owner => root,
    group => root,
    mode  => '0644',
  }

  concat { $udev_reverse_tether_rules_location :
    owner => root,
    group => root,
    mode  => '0644',
  }
}