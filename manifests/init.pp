# == Class: selendroid
#
# A class obtain an installation of selendroid and register it as a service
#
# === Parameters
#
# === Authors
#
# Christopher Johnson - cjohn@ceh.ac.uk
#
class selendroid (
  $java_home,
  $android_home,
  $nexus,
  $service_name   = 'selendroid',
  $service_ensure = true,
  $service_enable = true,
  $user           = 'selendroid',
  $group          = 'selendroid',
  $manage_user    = true,
  $manage_group   = true,
  $repo           = undef,
  $version        = undef
) {
  $installed_path = '/opt/selendroid/selendroid-server.jar'
  $udev_rules_location = '/etc/udev/rules.d/51-selendroid.rules'

  if $manage_user {
    user { $user :
      gid    => $group,
      ensure => present,
    }
  }

  if $manage_group {
    group { $group :
      ensure => present,
    }
  }

  file { '/opt/selendroid' :
    ensure => directory,
    owner  => $user,
    group  => $group,
  }

  nexus::artifact { $installed_path :
    nexus      => $nexus,
    group      => 'io.selendroid',
    artifact   => 'selendroid-standalone',
    extension  => 'jar',
    classifier => 'with-dependencies',
    version    => $version,
    repo       => $repo,
  }

  file { "/etc/default/${service_name}" :
    ensure  => file,
    owner   => root,
    group   => root,
    content => template("selendroid/default-selendroid.erb"),
    notify  => Service[$service_name],
  }

  file { "/etc/init.d/${service_name}" :
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 755,
    content => template('selendroid/init-selendroid.erb'),
    notify  => Service[$service_name],
  }

  service { $service_name :
    ensure => $service_ensure,
    enable => $service_enable,  
  }

  concat { $udev_rules_location :
    owner => root,
    group => root,
    mode  => '0644',
  }
}