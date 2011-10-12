require 'spec_helper'

describe "a generated attributes hash" do
  include FactoryGirl::Syntax::Methods

  before do
    define_model('User')

    define_model('Post', :title   => :string,
                         :body    => :string,
                         :summary => :string,
                         :user_id => :integer) do
      belongs_to :user
    end

    FactoryGirl.define do
      factory :user

      factory :post do
        title { "default title" }
        body { "default body" }
        summary { title }
        user
      end
    end
  end

  subject { attributes_for(:post, :title => 'overridden title') }

  it "assigns an overridden value" do
    subject[:title].should == "overridden title"
  end

  it "assigns a default value" do
    subject[:body].should == "default body"
  end

  it "assigns a lazy, dependent attribute" do
    subject[:summary].should == "overridden title"
  end

  it "doesn't assign associations" do
    subject[:user_id].should be_nil
  end
end

describe "calling `attributes_for` with a block" do
  include FactoryGirl::Syntax::Methods

  before do
    define_model('Company', :name => :string)

    FactoryGirl.define do
      factory :company
    end
  end

  it "passes the hash of attributes" do
    attributes_for(:company, :name => 'thoughtbot') do |attributes|
      attributes[:name].should eq('thoughtbot')
    end
  end
end
