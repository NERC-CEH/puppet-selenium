require 'spec_helper'

describe 'selenium::device', :type => :define do
  let :pre_condition do
    'class { "selenium": java_home => "/java/home", android_home => "/android/home", }'
  end

  let(:facts) { { :concat_basedir => '/dne' } }

  let(:title) {'selenium-device' }

  let(:params) {{
    :vendor => 'vendor-test',
    :serial_number => 'Ran40m'
  }}

  it { should contain_concat__fragment('selenium-device_device').with(
    :target  => '/etc/udev/rules.d/51-selenium.rules',
  ) }

  it { should contain_concat('/etc/udev/rules.d/51-selenium.rules') }

  it { should contain_concat__fragment('selenium-device_tether').with(
    :target  => '/etc/udev/rules.d/81-selenium.rules',
  ) }

  it { should contain_file('/opt/selenium/selenium-device-reverse-tether.sh').with(
    :ensure => 'file',
    :owner  => 'root',
    :group  => 'root',
    :mode   => '0744'
  ) }

  it { should contain_concat('/etc/udev/rules.d/81-selenium.rules') }
end