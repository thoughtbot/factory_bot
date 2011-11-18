require 'spec_helper'

describe "an instance generated by a factory" do
  before do
    define_model("User")

    FactoryWoman.define do
      factory :user
    end
  end

  it "registers the user factory" do
    FactoryWoman.factory_by_name(:user).should be_a(FactoryWoman::Factory)
  end
end
