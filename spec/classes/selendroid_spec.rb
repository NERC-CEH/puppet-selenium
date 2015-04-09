require 'spec_helper'

describe 'selenium', :type => :class do 
  let(:default_facts) {{
    :concat_basedir => '/dne'
  }}
  
  let(:default_params) {{
    :java_home    => '/java/home',
    :android_home => '/android/home'
  }}
  
  describe 'when user is managed' do
    let(:facts) { default_facts }
    let(:params) { default_params.merge({
      :manage_group => false
    }) }
      
    it { should contain_user('selenium') }
  end

  describe 'when group is managed' do
    let(:facts) { default_facts }
    let(:params) { default_params.merge({
      :manage_group => true
    }) }
    it { should contain_group('selenium') }
  end

  describe 'when user isnt managed' do
    let(:facts) { default_facts }
    let(:params) { default_params.merge({
      :manage_user  => false
    }) }
      
    it { should_not contain_user('selenium') }
  end

  describe 'when group isnt managed' do
    let(:facts) { default_facts }
    let(:params) { default_params.merge({
      :manage_group => false
    }) }
    it { should_not contain_group('selenium') }
  end

  describe 'selenium directory' do
    let(:facts) { default_facts }
    let(:params) { default_params }
    it { should contain_file('/opt/selenium').with(
      :ensure => 'directory',
      :owner  => 'selenium',
      :group  => 'selenium'
    )}
  end

  describe 'nexus artifact' do
    let(:facts) { default_facts }
    let(:params) { default_params }
    it { should contain_nexus__artifact('/opt/selenium/selenium-server.jar').with(
      :group      => 'io.selenium',
      :artifact   => 'selenium-standalone',
      :extension  => 'jar',
      :classifier => 'with-dependencies'
    )}
  end

  describe 'wrapper script' do
    let(:facts) { default_facts }
    let(:params) { default_params }
    it { should contain_file('/opt/selenium/startup.sh').with(
      :ensure => 'file',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0755'
    ).that_notifies('Service[selenium]') }
  end

  describe 'selenium service' do
    let(:facts) { default_facts }
    let(:params) { default_params }
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
end