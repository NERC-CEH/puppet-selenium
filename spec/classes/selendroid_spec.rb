require 'spec_helper'

describe 'selendroid', :type => :class do 
  let(:params) { {
    :manage_user  => true,
    :java_home    => '/java/home',
    :android_home => '/android/home',
    :nexus        => 'https://oss.sonatype.org/service/local'
  } }
  
  it { should contain_user('selendroid') }
  it { should contain_group('selendroid') }

end