require 'spec_helper'

describe "autogenerate" do
  include FactoryGirl::Syntax::Methods

  context 'passing string with #N' do
    it "generates string increasing #N sequentialy" do
      autogenerate("nickname#N@email.com").should == "nickname1@email.com"
      autogenerate("nickname#N@email.com").should == "nickname2@email.com"
      autogenerate("nickname#N@email.com").should == "nickname3@email.com"
    end
  end

  context 'passing string without #N' do
    it "puts #N in string end" do
      autogenerate("nickname").should == "nickname1"
      autogenerate("nickname").should == "nickname2"
      autogenerate("nickname").should == "nickname3"
    end
  end
end
