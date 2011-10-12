require 'spec_helper'

describe "create multiple instances" do
  before do
    define_model('Post', :title => :string)

    FactoryGirl.define do
      factory(:post) do |post|
        post.title "Through the Looking Glass"
      end
    end
  end

  context "without default attributes" do
    subject { FactoryGirl.create_list(:post, 20) }

    its(:length) { should == 20 }

    it "creates all the posts" do
      subject.each do |record|
        record.should_not be_new_record
      end
    end

    it "uses the default factory values" do
      subject.each do |record|
        record.title.should == "Through the Looking Glass"
      end
    end
  end

  context "with default attributes" do
    subject { FactoryGirl.create_list(:post, 20, :title => "The Hunting of the Snark") }

    it "overrides the default values" do
      subject.each do |record|
        record.title.should == "The Hunting of the Snark"
      end
    end
  end
end

describe "calling `create_list` with a block" do
  include FactoryGirl::Syntax::Methods

  before do
    define_model('Company', :name => :string)

    FactoryGirl.define do
      factory :company
    end
  end

  it "passes each created instance" do
    create_list(:company, 2, :name => 'thoughtbot') do |company|
      raise
      company.should be_new_record
      company.name.should eq('thoughtbot')
    end
  end
end
