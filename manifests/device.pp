# == Define: selendroid::device
#
# A device definition, which should be set as being owned by the selendroid user
#
# === Parameters
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