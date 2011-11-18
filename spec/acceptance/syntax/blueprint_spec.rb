require 'spec_helper'

require 'factory_woman/syntax/blueprint'

describe "a blueprint" do
  before do
    define_model('User', :first_name => :string, :last_name => :string, :email => :string)

    Factory.sequence(:email) { |n| "somebody#{n}@example.com" }
    User.blueprint do
      first_name { 'Bill'                       }
      last_name  { 'Nye'                        }
      email      { FactoryWoman.generate(:email) }
    end
  end

  describe "after making an instance" do
    before do
      @instance = FactoryWoman.create(:user, :last_name => 'Rye')
    end

    it "uses attributes from the blueprint" do
      @instance.first_name.should == 'Bill'
    end

    it "evaluates attribute blocks for each instance" do
      @instance.email.should =~ /somebody\d+@example.com/
      FactoryWoman.create(:user).email.should_not == @instance.email
    end
  end
end
