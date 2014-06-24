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
  $vendor
) {
  concat::fragment { "${name}_device" :
    target  => $selendroid::udev_rules_location,
    content => template('selendroid/udev-fragment.erb'),
  }
}