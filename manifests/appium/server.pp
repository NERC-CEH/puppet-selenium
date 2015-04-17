# == Define: selenium::appium::server
#
# Sets up an instance of the appium application to run as a service
#
# === Parameters
# [*hub_host*]          The host which this appium instance should connect to
# [*hub_port*]          The port which the hub is running on
# [*port*]              which appium should run on
# [*chromedriver_port*] the port which the chromedriver will run on
# [*bootstrap_port*]    not too sure what this is (check the appium docs)
# [*android_home*]      location of your android sdk installation. Needed for driving android
# [*host*]              the hostname which the hub can contact this node on
# [*service_enable*]    the enabled value of the service (ubuntu only)
# [*service_ensure*]    the ensure value of the service (ubnutu only)
# [*user*]              which should run the appium service
# [*group*]             which should run the appium service
# [*headless*]          If this server should run headlessly (Linux only)
# [*headless_command*]  The command to use to start the server headlessly
# [*max_session*]       maximum amount of concurrent tests which can be run on this node
# ---
#   Lots of appium command switches see (http://appium.io/slate/en/master/?ruby#server-flags)
# ---
# [*custom_arguments*]  to be appended to the executable if unhandled by this module
# [*capabilities*]      a list of selenium browser capabilities
#
# === Authors
#
# Christopher Johnson - cjohn@ceh.ac.uk
#
define selenium::appium::server (
  $hub_host                 = $selenium::hub_host,
  $hub_port                 = $selenium::hub_port,
  $port                     = 4723,
  $chromedriver_port        = 9515,
  $bootstrap_port           = 4724,
  $android_home             = $selenium::android_home,
  $host                     = $fqdn,
  $service_enable           = true,
  $service_ensure           = true,
  $user                     = $selenium::user,
  $group                    = $selenium::group,
  $headless                 = false,
  $headless_command         = $selenium::headless_command,
  $max_session              = 1,
  $session_override         = false,
  $full_reset               = false,
  $no_reset                 = false,
  $pre_launch               = false,
  $log_timestamp            = false,
  $local_timezone           = false,
  $log_no_colors            = true,
  $native_instruments_lib   = false,
  $app_wait_package         = false,
  $app_wait_activity        = false,
  $android_coverage         = false,
  $safari                   = false,
  $default_device           = false,
  $force_iphone             = false,
  $force_ipad               = false,
  $show_sim_log             = false,
  $show_ios_log             = false,
  $use_keystore             = false,
  $no_perms_check           = false,
  $keep_keychains           = false,
  $strict_caps              = false,
  $isolate_sim_device       = false,
  $suppress_adb_kill_server = false,
  $custom_arguments         = [],
  $capabilities             = [
    {browserName => "Appium ${name}", maxInstances => 1, platform => 'MAC'}
  ]
) {
  if ! defined(Class['selenium::appium']) {
    fail('You must include the appium class in order to create an appium server')
  }

  # Create the appium node configuration
  $node_config    = "${selenium::config_path}/appium-${name}.json"
  $appium         = "${selenium::node_executable} ${selenium::appium_path}/bin/appium.js"
  
  file { $node_config :
    ensure  => file,
    owner   => $user,
    group   => $group,
    mode    => '0644',
    content => template('selenium/grid2-nodeconfig.erb'),
  }
  
  $command = [
    $selenium::node_executable, $selenium::appium_executable,
    '--port',                 $port,
    '--chromedriver-port',    $chromedriver_port,
    '--bootstrap-port',       $bootstrap_port,
    '--nodeconfig',           $node_config,
    '--log-level',            'warn',
    $session_override         ? { true => '--session-override',         default => ''},
    $full_reset               ? { true => '--full-reset',               default => ''},
    $no_reset                 ? { true => '--no-reset',                 default => ''},
    $pre_launch               ? { true => '--pre-launch',               default => ''},
    $log_timestamp            ? { true => '--log-timestamp',            default => ''},
    $local_timezone           ? { true => '--local-timezone',           default => ''},
    $log_no_colors            ? { true => '--log-no-colors',            default => ''},
    $native_instruments_lib   ? { true => '--native-instruments-lib',   default => ''},
    $app_wait_package         ? { true => '--app-wait-package',         default => ''},
    $app_wait_activity        ? { true => '--app-wait-activity',        default => ''},
    $android_coverage         ? { true => '--android-coverage',         default => ''},
    $safari                   ? { true => '--safari',                   default => ''},
    $default_device           ? { true => '--default-device',           default => ''},
    $force_iphone             ? { true => '--force-iphone',             default => ''},
    $force_ipad               ? { true => '--force-ipad',               default => ''},
    $show_sim_log             ? { true => '--show-sim-log',             default => ''},
    $show_ios_log             ? { true => '--show-ios-log',             default => ''},
    $use_keystore             ? { true => '--use-keystore',             default => ''},
    $no_perms_check           ? { true => '--no-perms-check',           default => ''},
    $keep_keychains           ? { true => '--keep-keychains',           default => ''},
    $strict_caps              ? { true => '--strict-caps',              default => ''},
    $isolate_sim_device       ? { true => '--isolate-sim-device',       default => ''},
    $suppress_adb_kill_server ? { true => '--suppress-adb-kill-server', default => ''}
  ]

  selenium::service { "appium-${name}":
    environment      => {
      'ANDROID_HOME' => $android_home,
    },
    command          => concat($command, $custom_arguments),
    user             => $user,
    group            => $group,
    service_ensure   => $service_ensure,
    service_enable   => $service_enable,
    subscribe        => File[$node_config],
    headless         => $headless,
    headless_command => $headless_command,
  }
}