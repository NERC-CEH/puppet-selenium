require 'spec_helper'

describe 'selenium::service', :type => :define do
  let(:pre_condition) { 'include selenium' }

  let(:title) {'selenium' }

  let(:params) {{
    :user => 'selenium',
    :group => 'selenium',
    :service_enable => true,
    :service_ensure => true
  }}
    
  context "on a Debian OS" do
    let(:facts) {{ 
      :concat_basedir => '/dne',
      :osfamily => 'Debian'
    }}

    it { should contain_file('/opt/selenium/selenium-startup.sh').with(
     :ensure => 'file',
     :owner  => 'selenium',
     :group  => 'selenium',
     :mode   => '0755'
    ).that_notifies('Service[selenium]') }

    it { should contain_file('/etc/init.d/selenium').with(
      :ensure => 'file',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0755'
    ).that_notifies('Service[selenium]')}

    it { should contain_service('selenium').with(
      :ensure => true,
      :enable => true
    ).that_requires('User[selenium]')}
  end

  context "on a Darwin OS" do
    let(:facts) {{ 
      :concat_basedir => '/dne',
      :osfamily => 'Darwin'
    }}

    it { should contain_file('/Users/selenium/Library/LaunchAgents/com.selenium.selenium.server.plist')}
  end
end
