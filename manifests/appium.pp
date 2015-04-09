# == Class: selenium::appium
#
# A class to obtain the appium package from nodejs. This class will manage the
# ownership of the downloaded node_module
#
# === Parameters
# [*user*]           The user who will be delegated the task of running appium
# [*group*]          The group of the user who will run appium
# [*installed_path*] The path where the appium module is installed.
#
# === Authors
#
# Christopher Johnson - cjohn@ceh.ac.uk
#
class selenium::appium (
  $user           = $selenium::user,
  $group          = $selenium::group,
  $installed_path = $selenium::appium_path,
  $version        = 'installed'
) {
  package { 'appium' :
    ensure   => $version,
    provider => 'npm'
  }

  file { $installed_path,
    owner   => $user,
    group   => $group,
    require => Package['appium']
  }
}