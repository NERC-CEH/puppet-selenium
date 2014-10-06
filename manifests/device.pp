# == Define: selendroid::device
#
# A device definition, which should be set as being owned by the selendroid user.
#
# Optionally this define can manage the set up of reverse tethering when the device
# is connected. The device must be rooted for this to work.
#
# === Parameters
#
# [*vendor*] The usb vendor which should be owned by the selendroid user
# [*serial_number*] The serial number of the device to be managed
# [*reverse_tether*] If reverse tethering should be enabled for this device
# [*device_link*] When rndis is enabled, your android device will create a new
#   networking device. Usually this is usb0 or rndis0.
# [*adb_location*] The location of adb to use for configuring reverse tethering
#   on the android device.
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
define selendroid::device (
  $vendor,
  $serial_number,
  $reverse_tether = $selendroid::reverse_tether,
  $device_link    = 'usb0',
  $adb_location   = $selendroid::adb_location,
  $netmask        = $selendroid::reverse_tether_netmask,
  $dns_server     = $selendroid::reverse_tether_dns_server,
  $dns_backup     = $selendroid::reverse_tether_dns_backup,
  $host_address   = '10.42.0.1',
  $device_address = '10.42.0.2'
) {
  # Manage the ownership of the device
  concat::fragment { "${name}_device" :
    target  => $selendroid::udev_device_rules_location,
    content => template('selendroid/udev-device-fragment.erb'),
  }

  if $reverse_tether {
    # Define a reverse tether script for this device and run this when the 
    # device is connected
    $tether_setup = "/opt/selendroid/${name}-reverse-tether.sh"
    file { $tether_setup :
      ensure  => file,
      mode    => 0744,
      owner   => root,
      group   => root,
      content => template('selendroid/reverse-tether.sh.erb'),
    }

    concat::fragment { "${name}_tether" :
      target  => $selendroid::udev_reverse_tether_rules_location,
      content => template('selendroid/udev-reverse-tether-fragment.erb'),
    }
  }
}