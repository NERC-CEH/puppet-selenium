# == Define: selenium::appium::server
#
# Sets up an instance of the appium application to run as a service
#
define selenium::appium::server (
  $hub_host           = $selenium::hub_host,
  $hub_port           = $selenium::hub_port,
  $port               = 4723,
  $chromedriver_port  = 9515,
  $bootstrap_port     = 4724,
  $android_home       = $selenium::android_home,
  $host               = $fqdn,
  $service_enable     = true,
  $service_ensure     = true,
  $user               = $selenium::appium::user,
  $group              = $selenium::appium::group
) {
  if ! defined(Class['selenium::appium']) {
    fail('You must include the appium class in order to create an appium server')
  }

  # Create the appium node configuration
  $node_config    = "${selenium::config_path}/appium-${name}.json"
  $service_name   = "appium-${name}"
  $appium         = "${selenium::appium_path}/bin/appium.js"
  
  file { $node_config :
    ensure  => file,
    owner   => $user,
    group   => $group,
    mode    => '0644',
    content => template('selenium/appium-nodeconfig.erb'),
  }

  case $::osfamily {
    Darwin: {
      $plist_label = "com.appium.${name}.server"
      $plist = "/Users/${user}/Library/LaunchAgents/${plist_label}.plist"
      # Mac OS X requires appium to run as an interactive user (i.e. logged in)
      # I don't think puppet can start a user specific service, you will need to 
      # (re)log the $user in after this puppet run.
      file { $plist :
        ensure  => file,
        owner   => $user,
        group   => $group,
        mode    => '0644',
        content => template('selenium/appium-plist.erb'),
      }
    }
    default: {
      $wrapper_script = "${selenium::selenium_dir}/appium-${name}-startup.sh"
      file { $wrapper_script :
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => '0755',
        content => template('selenium/appium-startup.erb'),
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
        require   => [
          User[$user],
          Package['appium'],
        ],
        subscribe => [
          File[$node_config],
          File[$wrapper_script]
        ],
      }
    }
  }
}