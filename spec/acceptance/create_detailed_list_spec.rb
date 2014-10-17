require 'spec_helper'

describe "create multiple detailed instances" do
  before do
    define_model('Post', title: :string, position: :integer)
  

    FactoryGirl.define do
      factory(:post) do |post|
        post.title "Into the Blue Yonder"
        post.position { rand(10**4) }
      end
    end
  end

  context "with singular detail hash" do
    subject { FactoryGirl.create_detailed_list(:post, 20, {title: ['Into the White Yonder']}) }
    
    its(:length) { should eq 20 }

    it "creates all the posts" do
      subject.each do |record|
        expect(record).not_to be_new_record
      end
    end

  end
end
