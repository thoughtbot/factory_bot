require "spec_helper"

shared_context "registering custom strategies" do
  before do
    define_class("NamedObject") do
      attr_accessor :name
    end
  end

  let(:custom_strategy) do
    Class.new do
      def result(evaluation)
        evaluation.object.tap do |instance|
          instance.name = "Custom strategy"
        end
      end
    end
  end
end

describe "register custom strategies" do
  include_context "registering custom strategies"

  before do
    FactoryGirl.define do
      factory :named_object do
        name "Great"
      end
    end
  end

  it "allows overriding default strategies" do
    FactoryGirl.build(:named_object).name.should == "Great"
    FactoryGirl.register_strategy(:build, custom_strategy)
    FactoryGirl.build(:named_object).name.should == "Custom strategy"
  end

  it "allows adding additional strategies" do
    FactoryGirl.register_strategy(:insert, custom_strategy)

    FactoryGirl.build(:named_object).name.should == "Great"
    FactoryGirl.insert(:named_object).name.should == "Custom strategy"
  end

  it "allows using the *_list method to build a list using a custom strategy" do
    FactoryGirl.register_strategy(:insert, custom_strategy)

    inserted_items = FactoryGirl.insert_list(:named_object, 2)
    inserted_items.length.should == 2
    inserted_items.map(&:name).should == ["Custom strategy", "Custom strategy"]
  end
end

describe "including FactoryGirl::Syntax::Methods when custom strategies have been declared" do
  include FactoryGirl::Syntax::Methods

  include_context "registering custom strategies"

  before do
    FactoryGirl.define do
      factory :named_object do
        name "Great"
      end
    end
  end

  it "allows adding additional strategies" do
    FactoryGirl.register_strategy(:insert, custom_strategy)

    insert(:named_object).name.should == "Custom strategy"
  end
end

describe "associations without overriding :strategy" do
  include_context "registering custom strategies"

  before do
    define_model("Post", user_id: :integer) do
      belongs_to :user
    end

    define_model("User", name: :string)

    FactoryGirl.define do
      factory :post do
        user
      end

      factory :user do
        name "John Doe"
      end
    end
  end

  it "uses the overridden create strategy to create the association" do
    FactoryGirl.register_strategy(:create, custom_strategy)
    post = FactoryGirl.build(:post)
    post.user.name.should == "Custom strategy"
  end
end

describe "associations overriding :strategy" do
  include_context "registering custom strategies"

  before do
    define_model("Post", user_id: :integer) do
      belongs_to :user
    end

    define_model("User", name: :string)

    FactoryGirl.define do
      factory :post do
        association :user, strategy: :insert
      end

      factory :user do
        name "John Doe"
      end
    end
  end

  it "uses the overridden create strategy to create the association" do
    FactoryGirl.register_strategy(:insert, custom_strategy)
    post = FactoryGirl.build(:post)
    post.user.name.should == "Custom strategy"
  end
end
