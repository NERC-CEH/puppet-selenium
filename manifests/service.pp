# == Define: selenium::server
#
# An internal define which sets up a command to run as a service. On Mac, this will occur when
# $user logs in. On linux this will run as a real service.
#
# SHOULD NOT BE CALLED OUTSIDE OF THIS MODULE
# === Authors
#
# Christopher Johnson - cjohn@ceh.ac.uk
#
define selenium::service (
  $user,
  $group,
  $service_enable,
  $service_ensure,
  $headless         = false,
  $headless_command = '',
  $environment      = {},
  $command          = [],
  $service_name     = $name,
) {
  # Check if we need to run this service headlessly. THIS DOES NOT WORK ON
  # Darwin or Windows
  $actual_command = $headless ? {
    true    => concat([$headless_command], $command),
    default => $command,
  }

  case $::osfamily {
    Darwin: {
      $plist_label = "com.selenium.${service_name}.server"
      $plist = "/Users/${user}/Library/LaunchAgents/${plist_label}.plist"
      # Mac OS X requires appium to run as an interactive user (i.e. logged in)
      # I don't think puppet can start a user specific service, you will need to
      # (re)log the $user in after this puppet run.
      file { $plist :
        ensure  => file,
        owner   => $user,
        group   => $group,
        mode    => '0644',
        content => template('selenium/service-plist.erb'),
      }
    }
    windows: {
      $batch = "c:/Users/${user}/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup/selenium-${service_name}.bat"

      file { $batch :
        ensure  => file,
        owner   => $user,
        group   => $group,
        mode    => '0755',
        content => template('selenium/wrapper-batch.erb'),
      }
    }
    default: {
      $wrapper_script = "${selenium::selenium_dir}/${service_name}-startup.sh"

      file { $wrapper_script :
        ensure  => file,
        owner   => $user,
        group   => $group,
        mode    => '0755',
        content => template('selenium/wrapper-script.erb'),
      }

      file { "/etc/init.d/${service_name}" :
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => '0755',
        content => template('selenium/init-service.erb'),
        notify  => Service[$service_name],
      }

      service { $service_name :
        ensure    => $service_ensure,
        enable    => $service_enable,
        require   => User[$user],
        subscribe => File[$wrapper_script],
      }
    }
  }
}
