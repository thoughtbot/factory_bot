describe "initialize_with with non-FG attributes" do
  include FactoryBot::Syntax::Methods

  before do
    define_model("User", name: :string, age: :integer) do
      def self.construct(name, age)
        new(name: name, age: age)
      end
    end

    FactoryBot.define do
      factory :user do
        initialize_with { User.construct("John Doe", 21) }
      end
    end
  end

  subject    { build(:user) }
  its(:name) { should eq "John Doe" }
  its(:age)  { should eq 21 }
end

describe "initialize_with with FG attributes that are transient" do
  include FactoryBot::Syntax::Methods

  before do
    define_model("User", name: :string) do
      def self.construct(name)
        new(name: "#{name} from .construct")
      end
    end

    FactoryBot.define do
      factory :user do
        transient do
          name { "Handsome Chap" }
        end

        initialize_with { User.construct(name) }
      end
    end
  end

  subject    { build(:user) }
  its(:name) { should eq "Handsome Chap from .construct" }
end

describe "initialize_with non-ORM-backed objects" do
  include FactoryBot::Syntax::Methods

  before do
    define_class("ReportGenerator") do
      attr_reader :name, :data

      def initialize(name, data)
        @name = name
        @data = data
      end
    end

    FactoryBot.define do
      sequence(:random_data) { Array.new(5) { Kernel.rand(200) } }

      factory :report_generator do
        transient do
          name { "My Awesome Report" }
        end

        initialize_with { ReportGenerator.new(name, FactoryBot.generate(:random_data)) }
      end
    end
  end

  it "allows for overrides" do
    expect(build(:report_generator, name: "Overridden").name).to eq "Overridden"
  end

  it "generates random data" do
    expect(build(:report_generator).data.length).to eq 5
  end
end

describe "initialize_with parent and child factories" do
  before do
    define_class("Awesome") do
      attr_reader :name

      def initialize(name)
        @name = name
      end
    end

    FactoryBot.define do
      factory :awesome do
        transient do
          name { "Great" }
        end

        initialize_with { Awesome.new(name) }

        factory :sub_awesome do
          transient do
            name { "Sub" }
          end
        end

        factory :super_awesome do
          initialize_with { Awesome.new("Super") }
        end
      end
    end
  end

  it "uses the parent's constructor when the child factory doesn't assign it" do
    expect(FactoryBot.build(:sub_awesome).name).to eq "Sub"
  end

  it "allows child factories to override initialize_with" do
    expect(FactoryBot.build(:super_awesome).name).to eq "Super"
  end
end

describe "initialize_with implicit constructor" do
  before do
    define_class("Awesome") do
      attr_reader :name

      def initialize(name)
        @name = name
      end
    end

    FactoryBot.define do
      factory :awesome do
        transient do
          name { "Great" }
        end

        initialize_with { new(name) }
      end
    end
  end

  it "instantiates the correct object" do
    expect(FactoryBot.build(:awesome, name: "Awesome name").name).to eq "Awesome name"
  end
end

describe "initialize_with doesn't duplicate assignment on attributes accessed from initialize_with" do
  before do
    define_class("User") do
      attr_reader :name
      attr_accessor :email

      def initialize(name)
        @name = name
      end
    end

    FactoryBot.define do
      sequence(:email) { |n| "person#{n}@example.com" }

      factory :user do
        email

        name { email.gsub(/\@.+/, "") }

        initialize_with { new(name) }
      end
    end
  end

  it "instantiates the correct object" do
    built_user = FactoryBot.build(:user)
    expect(built_user.name).to eq "person1"
    expect(built_user.email).to eq "person1@example.com"
  end
end

describe "initialize_with has access to all attributes for construction" do
  it "assigns attributes correctly" do
    define_class("User") do
      attr_reader :name, :email, :ignored

      def initialize(attributes = {})
        @name = attributes[:name]
        @email = attributes[:email]
        @ignored = attributes[:ignored]
      end
    end

    FactoryBot.define do
      sequence(:email) { |n| "person#{n}@example.com" }

      factory :user do
        transient do
          ignored { "of course!" }
        end

        email

        name { email.gsub(/\@.+/, "") }

        initialize_with { new(attributes) }
      end
    end

    user_with_attributes = FactoryBot.build(:user)
    expect(user_with_attributes.email).to eq "person1@example.com"
    expect(user_with_attributes.name).to eq "person1"
    expect(user_with_attributes.ignored).to be_nil
  end
end

describe "initialize_with with an 'attributes' attribute" do
  it "assigns attributes correctly" do
    define_class("User") do
      attr_reader :name

      def initialize(attributes:)
        @name = attributes[:name]
      end
    end

    FactoryBot.define do
      factory :user do
        attributes { { name: "Daniel" } }
        initialize_with { new(attributes) }
      end
    end

    user = FactoryBot.build(:user)

    expect(user.name).to eq("Daniel")
  end
end

describe "initialize_with for a constructor that requires a block" do
  it "executes the block correctly" do
    define_class("Awesome") do
      attr_reader :output

      def initialize(&block)
        @output = instance_exec(&block)
      end
    end

    FactoryBot.define do
      factory :awesome do
        initialize_with { new { "Output" } }
      end
    end

    expect(FactoryBot.build(:awesome).output).to eq "Output"
  end
end
