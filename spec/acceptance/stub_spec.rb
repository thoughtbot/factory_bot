require 'spec_helper'
require 'acceptance/acceptance_helper'

describe "a generated stub instance" do
  before do
    define_model('User')

    define_model('Post', :title   => :string,
                         :body    => :string,
                         :user_id => :integer) do
      belongs_to :user
    end

    FactoryGirl.define do
      factory :user do
      end

      factory :post do
        title { "default title" }
        body { "default body" }
        user
      end
    end
  end

  subject { Factory.stub(:post, :title => 'overridden title') }

  it "assigns a default attribute" do
    subject.body.should == 'default body'
  end

  it "assigns an overridden attribute" do
    subject.title.should == 'overridden title'
  end

  it "assigns associations" do
    subject.user.should_not be_nil
  end

  it "assigns association id" do
    subject.user_id.should == subject.user.id
  end

  it "assigns association id via override" do
    other_stub = Factory.stub(:post, :user => Factory.stub(:user))
    other_stub.user_id.should == other_stub.user.id
  end

  it "has an id" do
    subject.id.should > 0
  end

  it "generates unique ids" do
    other_stub = Factory.stub(:post)
    subject.id.should_not == other_stub.id
  end

  it "isn't a new record" do
    should_not be_new_record
  end

  it "disables connection" do
    lambda { subject.connection }.should raise_error(RuntimeError)
  end

  it "disables update_attribute" do
    lambda { subject.update_attribute(:title, "value") }.should raise_error(RuntimeError)
  end

  it "disables reload" do
    lambda { subject.reload }.should raise_error(RuntimeError)
  end

  it "disables destroy" do
    lambda { subject.destroy }.should raise_error(RuntimeError)
  end

  it "disables save" do
    lambda { subject.save }.should raise_error(RuntimeError)
  end

  it "disables increment" do
    lambda { subject.increment!(:age) }.should raise_error(RuntimeError)
  end
end

