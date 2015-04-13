require 'spec_helper'

describe 'selenium::udev', :type => :class do
  let(:pre_condition) { 'include selenium' }

  let(:facts) { {
    :concat_basedir => '/dne',
    :osfamily => 'Debian'
  } }

  let(:params) {{ :version => 'some-version' }}

  it { should contain_package('appium').with(
    :ensure   => 'some-version',
    :provider => 'npm'
  ) }

  it { should contain_file('/usr/lib/node_modules/appium').with(
    :recurse => true,
    :owner   => 'selenium',
    :group   => 'selenium'
  ).that_requires('Package[appium]')}

end