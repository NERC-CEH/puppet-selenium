require 'spec_helper'

describe 'selenium::appium::server', :type => :define do
  let :pre_condition do
    'include selenium
    include selenium::appium'
  end

  let(:facts) { { :concat_basedir => '/dne' } }

  let(:title) {'iOS' }

  it { should contain_file('/etc/selenium/appium-iOS.json').with(
    :ensure => 'file',
    :owner  => 'selenium',
    :group  => 'selenium',
    :mode   => '0644'
  ) }

  it { should contain_selenium__service('appium-iOS').with(
    :user           => 'selenium',
    :group          => 'selenium',
    :service_enable => true,
    :service_ensure => true
  ).that_subscribes_to('File[/etc/selenium/appium-iOS.json]') }
end