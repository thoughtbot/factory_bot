require "spec_helper"

describe 'FactoryGirlStepHelpers::HumanHashToAttributeHash' do
  before do
    Object.any_instance.stubs(:World)
    require "factory_girl/step_definitions"
  end

  describe "#attributes" do
    context "without associations" do
      it "transforms keys to symbols " do
        subject({'name' => 'John', 'age' => '42'}).attributes.should == {:name => 'John', :age => '42'}
      end

      it "copes with an empty human_hash" do
        subject({}, []).attributes.should == {}
      end
    end
  end

  def subject(human_hash, associations = [])
    FactoryGirlStepHelpers::HumanHashToAttributeHash.new(human_hash, associations)
  end
end

