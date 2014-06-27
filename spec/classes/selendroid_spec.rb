require 'spec_helper'

describe 'selendroid', :type => :class do 
  let(:default_facts) {{
    :concat_basedir => '/dne'
  }}
  
  describe 'when user is managed' do  
    let(:params) { {
      :manage_user  => true,
      :java_home    => '/java/home',
      :android_home => '/android/home'
    } }
      
    it { should contain_user('selendroid') }
  end

  describe 'when group is managed' do
    let(:params) { {
      :manage_group => true,
      :java_home    => '/java/home',
      :android_home => '/android/home'
    } }
    it { should contain_group('selendroid') }
  end

  describe 'when user isnt managed' do
    let(:params) { {
      :manage_user  => false,
      :java_home    => '/java/home',
      :android_home => '/android/home'
    } }
      
    it { should_not contain_user('selendroid') }
  end

  describe 'when group isnt managed' do
    let(:params) { {
      :manage_group => false,
      :java_home    => '/java/home',
      :android_home => '/android/home'
    } }
    it { should_not contain_group('selendroid') }
  end
end