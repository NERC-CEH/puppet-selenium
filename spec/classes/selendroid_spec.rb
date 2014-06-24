require 'spec_helper'

describe 'selendroid', :type => :class do 
  context 'manage selendroid user' do
    let(:params) { {:manage_user => true} }
    it { should contain_user('selendroid') }
  end
end