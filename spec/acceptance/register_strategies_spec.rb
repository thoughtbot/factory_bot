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
    FactoryBot.define do
      factory :named_object do
        name { "Great" }
      end
    end
  end

  it "allows overriding default strategies" do
    expect(FactoryBot.build(:named_object).name).to eq "Great"
    FactoryBot.register_strategy(:build, custom_strategy)
    expect(FactoryBot.build(:named_object).name).to eq "Custom strategy"
  end

  it "allows adding additional strategies" do
    FactoryBot.register_strategy(:insert, custom_strategy)

    expect(FactoryBot.build(:named_object).name).to eq "Great"
    expect(FactoryBot.insert(:named_object).name).to eq "Custom strategy"
  end

  it "allows using the *_list method to build a list using a custom strategy" do
    FactoryBot.register_strategy(:insert, custom_strategy)

    inserted_items = FactoryBot.insert_list(:named_object, 2)
    expect(inserted_items.length).to eq 2
    expect(inserted_items.map(&:name)).to eq ["Custom strategy", "Custom strategy"]
  end

  it "allows using the *_pair method to build a list using a custom strategy" do
    FactoryBot.register_strategy(:insert, custom_strategy)

    inserted_items = FactoryBot.insert_pair(:named_object)
    expect(inserted_items.length).to eq 2
    expect(inserted_items.map(&:name)).to eq ["Custom strategy", "Custom strategy"]
  end
end

describe "including FactoryBot::Syntax::Methods when custom strategies have been declared" do
  include FactoryBot::Syntax::Methods

  include_context "registering custom strategies"

  before do
    FactoryBot.define do
      factory :named_object do
        name { "Great" }
      end
    end
  end

  it "allows adding additional strategies" do
    FactoryBot.register_strategy(:insert, custom_strategy)

    expect(insert(:named_object).name).to eq "Custom strategy"
  end
end

describe "associations without overriding :strategy" do
  include_context "registering custom strategies"

  before do
    define_model("Post", user_id: :integer) do
      belongs_to :user
    end

    define_model("User", name: :string)

    FactoryBot.define do
      factory :post do
        user
      end

      factory :user do
        name { "John Doe" }
      end
    end
  end

  context "when the :use_parent_strategy config option has not been enabled" do
    before { FactoryBot.use_parent_strategy = nil }

    it "uses the overridden strategy on the association" do
      FactoryBot.register_strategy(:create, custom_strategy)

      post = FactoryBot.build(:post)
      expect(post.user.name).to eq "Custom strategy"
    end
  end

  context "when the :use_parent_strategy config option has been enabled" do
    before { FactoryBot.use_parent_strategy = true }

    it "uses the parent strategy on the association" do
      FactoryBot.register_strategy(:create, custom_strategy)

      post = FactoryBot.build(:post)
      expect(post.user.name).to eq "John Doe"
    end
  end
end

describe "associations overriding :strategy" do
  include_context "registering custom strategies"

  before do
    define_model("Post", user_id: :integer) do
      belongs_to :user
    end

    define_model("User", name: :string)

    FactoryBot.define do
      factory :post do
        association :user, strategy: :insert
      end

      factory :user do
        name { "John Doe" }
      end
    end
  end

  it "uses the overridden create strategy to create the association" do
    FactoryBot.register_strategy(:insert, custom_strategy)
    post = FactoryBot.build(:post)
    expect(post.user.name).to eq "Custom strategy"
  end
end
