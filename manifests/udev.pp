# == Class: selenium::udev
#
# A class to set up the ownership of real devices connected to a box
#
# === Authors
#
# Christopher Johnson - cjohn@ceh.ac.uk
#
class selenium::udev {
  concat { $selenium::udev_device_rules_location :
    owner => root,
    group => root,
    mode  => '0644',
  }

  concat { $selenium::udev_reverse_tether_rules_location :
    owner => root,
    group => root,
    mode  => '0644',
  }
}