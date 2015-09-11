# == Class: selenium::appium
#
# A class to obtain the appium package from nodejs. This class will manage the
# ownership of the downloaded node_module
#
# === Parameters
# [*version*] The version of appium to install
#
# === Authors
#
# Christopher Johnson - cjohn@ceh.ac.uk
#
class selenium::appium (
  $version = 'installed'
) {
  package { 'appium' :
    ensure   => $version,
    provider => 'npm'
  }

  file { $selenium::appium_path :
    recurse => true,
    owner   => $selenium::user,
    group   => $selenium::group,
    require => Package['appium']
  }
}
