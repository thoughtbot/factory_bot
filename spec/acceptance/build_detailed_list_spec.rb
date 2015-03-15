require 'spec_helper'

describe "build multiple instances" do
  before do
    define_model('Post', title: :string, author: :string, position: :integer)
  
    FactoryGirl.define do
      factory(:post) do |post|
        post.title "Into the Blue Yonder"
        post.author "High Lord Frank of the Summer Isles"
        post.position { rand(10**4) }
      end
    end
  end

  context "with singular value for details" do
    subject { FactoryGirl.build_detailed_list(:post, 20, 
                                              title: ["Into the White Yonder"]) }
    
    its(:length) { should eq 20 }

    it "builds (but doesn't save) all the posts" do
      subject.each do |record|
        expect(record).to be_new_record
      end
    end

    it "overrides the value for the provided attribute for the first post" do
      expect(subject.first.title).to eq "Into the White Yonder"
    end

    it "only overrides the first post in the list" do
      subject[1..-1].each do |record|
        expect(record.title).to eq "Into the Blue Yonder"
      end
    end

    it "only overrides the provided attribute in the details hash" do
      expect(subject.first.author).to eq "High Lord Frank of the Summer Isles"
    end
  end
  
  context "with a block" do
    subject do 
      FactoryGirl.build_detailed_list(:post, 20, title: [ "Into the White Yonder"]) do |post|
        post.position = post.id
      end
    end

    it "correctly uses the set value" do
      subject.each_with_index do |record, index|
        expect(record.position).to eq record.id 
      end
    end 
  end
end
