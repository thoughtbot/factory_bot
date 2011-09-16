require 'spec_helper'

describe FactoryGirl::Callback do
  it "has a name" do
    FactoryGirl::Callback.new(:after_create, lambda {}).name.should == :after_create
  end

  it "converts strings to symbols" do
    FactoryGirl::Callback.new("after_create", lambda {}).name.should == :after_create
  end

  it "runs its block with no parameters" do
    ran_with = nil
    FactoryGirl::Callback.new(:after_create, lambda { ran_with = [] }).run(:one, :two)
    ran_with.should == []
  end

  it "runs its block with one parameter" do
    ran_with = nil
    FactoryGirl::Callback.new(:after_create, lambda { |one| ran_with = [one] }).run(:one, :two)
    ran_with.should == [:one]
  end

  it "runs its block with two parameters" do
    ran_with = nil
    FactoryGirl::Callback.new(:after_create, lambda { |one, two| ran_with = [one, two] }).run(:one, :two)
    ran_with.should == [:one, :two]
  end

  it "allows valid callback names to be assigned" do
    FactoryGirl::Callback::VALID_NAMES.each do |callback_name|
      expect { FactoryGirl::Callback.new(callback_name, lambda {}) }.
        to_not raise_error(FactoryGirl::InvalidCallbackNameError)
    end
  end

  it "raises if an invalid callback name is assigned" do
    expect { FactoryGirl::Callback.new(:magic_fairies, lambda {}) }.
      to raise_error(FactoryGirl::InvalidCallbackNameError, /magic_fairies is not a valid callback name/)
  end
end
