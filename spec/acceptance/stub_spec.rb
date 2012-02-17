require 'spec_helper'

describe "a stubbed instance" do
  include FactoryGirl::Syntax::Methods

  before do
    define_model('User')

    define_model('Post', :user_id => :integer) do
      belongs_to :user
    end

    FactoryGirl.define do
      factory :user

      factory :post do
        user
      end
    end
  end

  subject { build_stubbed(:post) }

  it "acts as if it came from the database" do
    should_not be_new_record
  end

  it "assigns associations and acts as if it is saved" do
    subject.user.should be_kind_of(User)
    subject.user.should_not be_new_record
  end
end

describe "a stubbed instance overriding strategy" do
  include FactoryGirl::Syntax::Methods

  def define_factories_with_method
    FactoryGirl.define do
      factory :user

      factory :post do
        association(:user, :method => :build)
      end
    end
  end

  def define_factories_with_strategy
    FactoryGirl.define do
      factory :user

      factory :post do
        association(:user, :strategy => :build)
      end
    end
  end

  before do
    define_model('User')
    define_model('Post', :user_id => :integer) do
      belongs_to :user
    end
  end

  context "associations declared with :strategy" do
    before  { define_factories_with_strategy }
    subject { build_stubbed(:post) }

    it "acts as if it is saved in the database" do
      should_not be_new_record
    end

    it "assigns associations and acts as if it is saved" do
      subject.user.should be_kind_of(User)
      subject.user.should_not be_new_record
    end
  end

  context "associations declared with :method" do
    before  { define_factories_with_method }
    subject { build_stubbed(:post) }

    it "acts as if it is saved in the database" do
      should_not be_new_record
    end

    it "assigns associations and acts as if it is saved" do
      subject.user.should be_kind_of(User)
      subject.user.should_not be_new_record
    end
  end
end
