require 'spec_helper'

require 'factory_girl/syntax/sham'

describe "a factory using sham syntax" do
  before do
    define_model('User', :first_name => :string,
                         :last_name  => :string,
                         :email      => :string,
                         :username   => :string)

    Sham.name        { "Name" }
    Sham.email       { "somebody#{rand(5)}@example.com" }
    Sham.username("FOO") { |c| "User-#{c}" }

    FactoryGirl.define do
      factory :user do
        first_name { Sham.name }
        last_name  { Sham.name }
        email      { Sham.email }
        username   { Sham.username }
      end
    end
  end

  describe "after making an instance" do
    before do
      @instance = FactoryGirl.create(:user, :last_name => 'Rye')
    end

    it "supports a sham called 'name'" do
      @instance.first_name.should == 'Name'
    end

    it "supports shams with starting values" do
      @instance.username.should == 'User-FOO'
    end

    it "uses the sham for the email" do
      @instance.email.should =~ /somebody\d@example.com/
    end
  end
end
