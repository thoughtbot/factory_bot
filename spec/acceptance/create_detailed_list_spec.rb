require 'spec_helper'

describe "create multiple detailed instances" do
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
    subject { FactoryGirl.create_detailed_list(:post, 5, 
                                               titles: ["Into the White Yonder"]) }
    
    its(:length) { should eq 5 }

    it "creates all the posts" do
      subject.each do |record|
        expect(record).not_to be_new_record
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

  context "with multiple values for details" do
    subject { FactoryGirl.create_detailed_list(:post, 20, 
                                 titles: [ "Into the White Yonder", 
                                          "Into the Yellow Yonder", 
                                          "Into the ... I don't know - Purple? Yonder"]) }
    
    it "overrides values for the second post" do
      expect(subject.second.title).to eq "Into the Yellow Yonder"
    end
    
    it "overrides values for the third post" do
      expect(subject.third.title).to eq "Into the ... I don't know - Purple? Yonder"
    end

    it "leaves the remaining posts alone" do
      subject[3..-1].each do |record|
        expect(record.title).to eq "Into the Blue Yonder"
      end
    end
  end

  context "with both an array and a normal value" do
    subject { FactoryGirl.create_detailed_list(:post, 20, title: "Into the Yellow Yonder", titles: [ "Into the Black Yonder"]) }

    it "overrides the first post" do
      expect(subject.first.title).to eq "Into the Black Yonder"
    end

    it "overrides the value of the remaining posts" do
      subject[1..-1].each do |record|
        expect(record.title).to eq "Into the Yellow Yonder"
      end
    end
  end

  context "with multiple attributes and singular values" do
    subject { FactoryGirl.create_detailed_list(:post, 20, 
                                  titles: [ "Into the White Yonder", 
                                           "Into the Yellow Yonder", 
                                           "Into the ... I don't know - Purple? Yonder"],
                                  authors: [ "Frank's distant cousin", 
                                            "James the Third, or Fourth" ]) }
  
    it "overrides all provided attributes" do
      expect(subject.first.title).to eq "Into the White Yonder"
      expect(subject.first.author).to eq "Frank's distant cousin"
    end

    it "doesn't override when the provided attribute has no value" do
      expect(subject.third.title).to eq "Into the ... I don't know - Purple? Yonder"
      expect(subject.third.author).to eq "High Lord Frank of the Summer Isles"
    end
  end

  context "with a block" do
    subject do
      FactoryGirl.create_detailed_list(:post, 20, titles: ["Into the Block"]) do |post|
        post.position = post.id
      end
    end

    it "uses the new values" do
      subject.each_with_index do |record, index|
        expect(record.position).to eq record.id
      end
    end
  end

  context "with override for all values" do
    subject do
      FactoryGirl.create_detailed_list( :post, 5, 
                                        titles: ["Into the Black Yonder"] , 
                                        author: "Frank")
    end
    
    it "overides all values with the provided secondary hash" do
      expect(subject.first.title).to eq "Into the Black Yonder"
      expect(subject.first.author).to eq "Frank"
      
      subject[1..-1].each do |record|
        expect(record.title).to eq "Into the Blue Yonder"
        expect(record.author).to eq "Frank"
      end
    end
  end
end

describe "multiple creates and transient attributes to dynamically build attribute lists" do
  before do
    define_model('User', name: :string) do
      has_many :posts
    end

    define_model('Post', title: :string, user_id: :integer) do
      belongs_to :user
    end

    FactoryGirl.define do 
      factory :post do
        title "Into the Blue Yonder"
        user
      end

      factory :user do
        name "Frank"
        
        factory :user_with_posts do
          transient do 
            posts_count 5
          end
        
          after(:create) do |user, evaluator|
            FactoryGirl.create_detailed_list(:post, evaluator.posts_count, user: user)
          end
        end
      end
    end
  end

  it "generates the correct number of posts" do
    expect(FactoryGirl.create(:user_with_posts).posts.length).to eq 5 
  end
 
  it "allows the number of posts to be modified" do
    expect(FactoryGirl.create(:user_with_posts, posts_count: 2).posts.length).to eq 2
  end
end
