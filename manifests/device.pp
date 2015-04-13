# == Define: selenium::device
#
# A device definition, which should be set as being owned by the selenium user.
#
# Optionally this define can manage the set up of reverse tethering when the device
# is connected. The device must be rooted for this to work.
#
# === Parameters
#
# [*vendor*] The usb vendor which should be owned by the selenium user
# [*serial_number*] The serial number of the device to be managed
# [*reverse_tether*] If reverse tethering should be enabled for this device
# [*device_link*] When rndis is enabled, your android device will create a new
#   networking device. Usually this is usb0 or rndis0.
# [*adb_location*] The location of adb to use for configuring reverse tethering
#   on the android device.
# [*adb_user*] The user which should be running the adb server
# [*dns_server*] The dns server the android device should use
# [*dns_backup*] The backup dns server the android device should use
# [*host_address*] The ip address of the host which the android will be using as
#   gateway 
# [*device_address*] The ip address the android device will be assigned
#
# === Authors
#
# Christopher Johnson - cjohn@ceh.ac.uk
#
define selenium::device (
  $vendor,
  $serial_number,
  $reverse_tether = $selenium::reverse_tether,
  $device_link    = 'usb0',
  $adb_location   = $selenium::adb_location,
  $adb_user       = $selenium::user,
  $netmask        = $selenium::reverse_tether_netmask,
  $dns_server     = $selenium::reverse_tether_dns_server,
  $dns_backup     = $selenium::reverse_tether_dns_backup,
  $host_address   = '10.42.0.1',
  $device_address = '10.42.0.2'
) {
  if ! defined(Class['selenium::udev']) {
    fail('You must include the selenium udev in order to manage a device')
  }
  # Manage the ownership of the device
  concat::fragment { "${name}_device" :
    target  => $selenium::udev_device_rules_location,
    content => template('selenium/udev-device-fragment.erb'),
  }

  if $reverse_tether {
    # Define a reverse tether script for this device and run this when the 
    # device is connected
    $tether_setup = "/opt/selenium/${name}-reverse-tether.sh"
    file { $tether_setup :
      ensure  => file,
      mode    => 0744,
      owner   => root,
      group   => root,
      content => template('selenium/reverse-tether.sh.erb'),
    }

    concat::fragment { "${name}_tether" :
      target  => $selenium::udev_reverse_tether_rules_location,
      content => template('selenium/udev-reverse-tether-fragment.erb'),
    }
  }
}