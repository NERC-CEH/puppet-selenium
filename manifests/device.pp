# == Define: selendroid::device
#
# A device definition, which should be set as being owned by the selendroid user
#
# === Parameters
#
# [*vendor*] The usb vendor which should be owned by the selendroid user
#
# === Authors
#
# Christopher Johnson - cjohn@ceh.ac.uk
#
define selendroid::device (
  $vendor,
  $serial_number,
  $reverse_tether = true,
  $adb_location   = $selendroid::adb_location,
  $netmask        = $selendroid::reverse_tether_netmask,
  $dns_server     = $selendroid::reverse_tether_dns_server,
  $dns_backup     = $selendroid::reverse_tether_dns_backup
  $host_address   = '10.42.0.1',
  $device_address = '10.42.0.2',
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
      mode    => 0744,
      owner   => root,
      group   => root,
      content => template('selendroid/reverse-tether.sh.erb'),
    }

    concat::fragment { "${name}_device" :
      target  => $selendroid::udev_reverse_tether_rules_location,
      content => template('selendroid/udev-reverse-tether-fragment.erb'),
    }
  }
}