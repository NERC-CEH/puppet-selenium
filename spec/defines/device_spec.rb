require 'spec_helper'

describe 'selendroid::device', :type => :define do
  let :pre_condition do
    'class { "selendroid": java_home => "/java/home", android_home => "/android/home", }'
  end

  let(:facts) { { :concat_basedir => '/dne' } }

  let(:title) {'selendroid-device' }

  let(:params) {{
    :vendor => 'vendor-test'
  }}

  it { should contain_concat__fragment('selendroid-device_device').with(
    :target  => '/etc/udev/rules.d/51-selendroid.rules',
  ) }

  it { should contain_concat('/etc/udev/rules.d/51-selendroid.rules') }
end