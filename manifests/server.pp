# == Define: selenium::server
#
#
# === Parameters
#
#
# === Authors
#
# Christopher Johnson - cjohn@ceh.ac.uk
#
define selenium::server (
  $role,
  $hub_host          = $selenium::hub_host,
  $host              = $fqdn,
  $headless          = false,
  $service_enable    = true,
  $service_ensure    = true,
  $headless_command  = 'xvfb-run',
  $java_home         = $selenium::java_home,
  $user              = $selenium::appium::user
) {
  if ! $selenium::standalone_server {
    fail('You must provide the selenium base class with a selenium standalone server jar file to run')
  }

  $jar = $selenium::selenium_jar
  $wrapper_script = "${selenium::selenium_dir}/selenium-${name}-startup.sh"
  $service_name = "selenium-${name}"
  $role_options = $role ? {
    'node' => "-hubHost ${hub_host} -host ${host}",
    'hub'  => "",
  }

  $pre_command = $headless ? {
    true    => $headless_command,
    default => '',
  }

  file { $wrapper_script :
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template('selenium/selenium-startup.erb'),
    notify  => Service[$service_name],
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
    subscribe => File[$jar],
  }
}