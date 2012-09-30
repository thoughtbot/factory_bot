require 'spec_helper'

describe "autogenerate" do
  include FactoryGirl::Syntax::Methods

  context 'passing string with #N' do
    it "generates string increasing #N sequentialy" do
      FactoryGirl.define do
        sequence(:size, "a", aliases: [:count, :length]) {|n| "called-#{n}" }
      end

      autogenerate("nickname#N@email.com").should == "nickname1@email.com"
      autogenerate("nickname#N@email.com").should == "nickname2@email.com"
      autogenerate("nickname#N@email.com").should == "nickname3@email.com"
    end
  end
end
