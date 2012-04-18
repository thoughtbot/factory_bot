require "spec_helper"

describe 'FactoryGirlStepHelpers::HumanHashToAttributeHash' do
  before do
    Object.any_instance.stubs(:World)
    require "factory_girl/step_definitions"

    define_model('User', name: :string) do
      has_many :posts
    end

    define_model('Post', title: :string, user_id: :integer) do
      belongs_to :user
    end

    FactoryGirl.define do
      factory :post do
        title "Through the Looking Glass"
        user
      end

      factory :user do
        name "John Doe"
      end

    end
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

