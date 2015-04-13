require 'spec_helper'

describe 'selenium::udev', :type => :class do
  let(:pre_condition) { 'include selenium' }

  let(:facts) { { :concat_basedir => '/dne' } }

  it { should contain_concat('/etc/udev/rules.d/51-selenium.rules') }

  it { should contain_concat('/etc/udev/rules.d/81-selenium.rules') }
end