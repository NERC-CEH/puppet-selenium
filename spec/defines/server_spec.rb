require 'spec_helper'

describe 'selenium::server', :type => :define do
  let(:pre_condition) { 
    'class {"selenium": standalone_server => "local.jar"} ' 
  }

  let(:facts) { { :concat_basedir => '/dne' } }

  let(:title) { 'node' }

  it { should contain_selenium__service('selenium-node').with(
    :user           => 'selenium',
    :group          => 'selenium',
    :service_enable => true,
    :service_ensure => true
  ).that_subscribes_to('File["/opt/selenium/server.jar"]') }
end