require 'spec_helper'

describe 'selendroid', :type => :class do 
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
      
    it { should contain_user('selendroid') }
  end

  describe 'when group is managed' do
    let(:facts) { default_facts }
    let(:params) { default_params.merge({
      :manage_group => true
    }) }
    it { should contain_group('selendroid') }
  end

  describe 'when user isnt managed' do
    let(:facts) { default_facts }
    let(:params) { default_params.merge({
      :manage_user  => false
    }) }
      
    it { should_not contain_user('selendroid') }
  end

  describe 'when group isnt managed' do
    let(:facts) { default_facts }
    let(:params) { default_params.merge({
      :manage_group => false
    }) }
    it { should_not contain_group('selendroid') }
  end

  describe 'selendroid directory' do
    let(:facts) { default_facts }
    let(:params) { default_params }
    it { should contain_file('/opt/selendroid').with(
      :ensure => 'directory',
      :owner  => 'selendroid',
      :group  => 'selendroid'
    )}
  end

  describe 'nexus artifact' do
    let(:facts) { default_facts }
    let(:params) { default_params }
    it { should contain_nexus__artifact('/opt/selendroid/selendroid-server.jar').with(
      :group      => 'io.selendroid',
      :artifact   => 'selendroid-standalone',
      :extension  => 'jar',
      :classifier => 'with-dependencies'
    )}
  end

  describe 'wrapper script' do
    let(:facts) { default_facts }
    let(:params) { default_params }
    it { should contain_file('/opt/selendroid/startup.sh').with(
      :ensure => 'file',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0755'
    ).that_notifies('Service[selendroid]') }
  end

  describe 'selendroid service' do
    let(:facts) { default_facts }
    let(:params) { default_params }
    it { should contain_file('/etc/init.d/selendroid').with(
      :ensure => 'file',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0755'
    ).that_notifies('Service[selendroid]')}
    
    it { should contain_service('selendroid').with(
      :ensure => true,
      :enable => true
    ).that_requires('User[selendroid]')}
  end
end