require 'spec_helper'

describe 'selenium', :type => :class do 
  let(:default_facts) {{
    :concat_basedir => '/dne'
  }}
  
  let(:default_params) {{
    :standalone_server => 'server.jar'
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

  describe 'standalone_server' do
    let(:facts) { default_facts }
    let(:params) { default_params }
    it { should contain_file('/opt/selenium/server.jar').with(
      :ensure => 'file',
      :owner  => 'selenium',
      :group  => 'selenium',
      :mode   => '0755',
      :source => 'server.jar'
    )}
  end
end