require "spec_helper"

describe "initialize_with with non-FG attributes" do
  include FactoryGirl::Syntax::Methods

  before do
    define_model("User", :name => :string, :age => :integer) do
      def self.construct(name, age)
        new(:name => name, :age => age)
      end
    end

    FactoryGirl.define do
      factory :user do
        initialize_with { User.construct("John Doe", 21) }
      end
    end
  end

  subject    { build(:user) }
  its(:name) { should == "John Doe" }
  its(:age)  { should == 21 }
end

describe "initialize_with with FG attributes that are ignored" do
  include FactoryGirl::Syntax::Methods

  before do
    define_model("User", :name => :string) do
      def self.construct(name)
        new(:name => "#{name} from .construct")
      end
    end

    FactoryGirl.define do
      factory :user do
        ignore do
          name { "Handsome Chap" }
        end

        initialize_with { User.construct(name) }
      end
    end
  end

  subject    { build(:user) }
  its(:name) { should == "Handsome Chap from .construct" }
end

describe "initialize_with with FG attributes that are not ignored" do
  include FactoryGirl::Syntax::Methods

  before do
    define_model("User", :name => :string) do
      def self.construct(name)
        new(:name => "#{name} from .construct")
      end
    end

    FactoryGirl.define do
      factory :user do
        name { "Handsome Chap" }

        initialize_with { User.construct(name) }
      end
    end
  end

  it "assigns each attribute even if the attribute has been used in the constructor" do
    build(:user).name.should == "Handsome Chap"
  end
end

describe "initialize_with non-ORM-backed objects" do
  include FactoryGirl::Syntax::Methods

  before do
    define_class("ReportGenerator") do
      attr_reader :name, :data

      def initialize(name, data)
        @name = name
        @data = data
      end
    end

    FactoryGirl.define do
      sequence(:random_data) { 5.times.map { Kernel.rand(200) } }

      factory :report_generator do
        ignore do
          name "My Awesome Report"
        end

        initialize_with { ReportGenerator.new(name, FactoryGirl.generate(:random_data)) }
      end
    end
  end

  it "allows for overrides" do
    build(:report_generator, :name => "Overridden").name.should == "Overridden"
  end

  it "generates random data" do
    build(:report_generator).data.length.should == 5
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

    FactoryGirl.define do
      factory :awesome do
        ignore do
          name "Great"
        end

        initialize_with { Awesome.new(name) }

        factory :sub_awesome do
          ignore do
            name "Sub"
          end
        end

        factory :super_awesome do
          initialize_with { Awesome.new("Super") }
        end
      end
    end
  end

  it "uses the parent's constructor when the child factory doesn't assign it" do
    FactoryGirl.build(:sub_awesome).name.should == "Sub"
  end

  it "allows child factories to override initialize_with" do
    FactoryGirl.build(:super_awesome).name.should == "Super"
  end
end
