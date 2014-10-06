require 'spec_helper'

describe 'selendroid::device', :type => :define do
  let :pre_condition do
    'class { "selendroid": java_home => "/java/home", android_home => "/android/home", }'
  end

  let(:facts) { { :concat_basedir => '/dne' } }

  let(:title) {'selendroid-device' }

  let(:params) {{
    :vendor => 'vendor-test',
    :serial_number => 'Ran40m'
  }}

  it { should contain_concat__fragment('selendroid-device-fragment').with(
    :target  => '/etc/udev/rules.d/51-selendroid.rules',
  ) }

  it { should contain_concat('/etc/udev/rules.d/51-selendroid.rules') }

  it { should contain_concat__fragment('selendroid-reverse-tether-fragment').with(
    :target  => '/etc/udev/rules.d/81-selendroid.rules',
  ) }

   it { should contain_file('/opt/selendroid/selendroid-device-reverse-tether.sh').with(
      :ensure => 'file',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0744'
    )

  it { should contain_concat('/etc/udev/rules.d/81-selendroid.rules') }
end