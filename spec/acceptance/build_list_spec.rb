require 'spec_helper'

describe "build multiple instances" do
  before do
    define_model('Post', title: :string, position: :integer)

    FactoryGirl.define do
      factory(:post) do |post|
        post.title "Through the Looking Glass"
        post.position { rand(10**4) }
      end
    end
  end

  context "without default attributes" do
    subject { FactoryGirl.build_list(:post, 20) }

    its(:length) { should == 20 }

    it "builds (but doesn't save) all the posts" do
      subject.each do |record|
        record.should be_new_record
      end
    end

    it "uses the default factory values" do
      subject.each do |record|
        record.title.should == "Through the Looking Glass"
      end
    end
  end

  context "with default attributes" do
    subject { FactoryGirl.build_list(:post, 20, title: "The Hunting of the Snark") }

    it "overrides the default values" do
      subject.each do |record|
        record.title.should == "The Hunting of the Snark"
      end
    end
  end

  context "with a block" do
    subject do
      FactoryGirl.build_list(:post, 20, title: "The Listing of the Block") do |post|
        post.position = post.id
      end
    end

    it "correctly uses the set value" do
      subject.each_with_index do |record, index|
        record.position.should == record.id
      end
    end
  end
end
