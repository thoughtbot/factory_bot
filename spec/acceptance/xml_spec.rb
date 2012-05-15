# encoding: utf-8
require 'spec_helper'

describe FactoryGirl::Strategy::Xml do
  before do
    class Person
      attr_accessor :name, :gender, :weight
      attr_accessor :address
      attr_accessor :home_address
      attr_accessor :children
    end

    class Address
      attr_accessor :street, :city
    end

    class Child
      attr_accessor :name
    end

    class Post
      attr_accessor :name
    end

    class PostCollection < Array
      def tag_name
        "posts"
      end
    end
  end

  after(:each) do
    FactoryGirl.factories.clear
  end

  it "creates a new xml document representing the person class" do
    FactoryGirl.define do
      factory :person do
        name "Kurt"
      end
    end

    person = FactoryGirl.xml(:person)
    person.should_not be_nil
  end

  it "creates a new xml document representing the person class. Its attribute-values are stored as text" do
    FactoryGirl.define do
      factory :person do
        name    "Tom"
        weight  80
      end
    end

    person = FactoryGirl.xml(:person).to_xml
    parsed = Nokogiri::XML.parse(person)
    parsed.xpath("//person/name").text.should ==  "Tom"
    parsed.xpath("//person/weight").text.should ==  "80"
  end

  it "serializes associated models as child nodes" do
    FactoryGirl.define do
      factory :person do
        name "Mary"
        address
      end

      factory :address do
        street  "Mainstreet"
        city    "Bern"
      end
    end


    person = FactoryGirl.xml(:person).to_xml
    parsed = Nokogiri::XML.parse(person)
    parsed.xpath("//person/address/city").text.should ==  "Bern"
  end

  it "serializes an associated array as an array of child nodes" do
    FactoryGirl.define do
      factory :person do
        name "Tom"
        children { [FactoryGirl.xml(:child), FactoryGirl.xml(:child)]}
      end
      factory :child do
        name "Lucy"
      end
    end

    person = FactoryGirl.xml(:person).to_xml
    parsed = Nokogiri::XML.parse(person)
    parsed.xpath("//person/children[@type='array']").first.elements.size.should == 2
  end

  it "serializes the model inside an array, if the option is set" do
    FactoryGirl.define do
      factory :person do
        name "Martin"

        after(:build) do |p|
          p.xml_config do |c|
            c.decorate_with_array
          end
        end
      end
    end
    person = FactoryGirl.xml(:person).to_xml
    parsed = Nokogiri::XML.parse(person)
    parsed.xpath("//people/person/name").text.should ==  "Martin"
  end

  it "serializes the model inside an array, if the option is set. An optional name may be supplied" do
    FactoryGirl.define do
      factory :person do
        name "Martin"

        after(:build) do |p|
          p.xml_config do |c|
            c.decorate_with_array :name => :men
          end
        end
      end
    end
    person = FactoryGirl.xml(:person).to_xml
    parsed = Nokogiri::XML.parse(person)
    parsed.xpath("//men/person/name").text.should ==  "Martin"
  end

  it "can serialize an enuberable directly as array" do
    FactoryGirl.define do
      factory :post do
        name    "Post"
      end

      factory :post_collection do
      end
    end

    container = FactoryGirl.xml(:post_collection)
    3.times {container << FactoryGirl.xml(:post)}
    parsed = Nokogiri::XML.parse(container.to_xml)
    parsed.xpath("//posts/post").size.should == 3
  end

  context "embedded in an array" do

    let (:posts) {FactoryGirl.xml(:post_collection)}

    it "suppresses the decoration serialisation, even if definied before" do
      FactoryGirl.define do
        factory :post do
          name    "Post"
          after(:build) do |p|
            p.xml_config do |c|
              c.decorate_with_array :name => :my_posts
            end
          end
        end

        factory :post_collection do
        end
      end

      post =  FactoryGirl.xml(:post)
      post.factory_xml_config.decorate_with_array(:disable=>true)
      posts << post

      parsed = Nokogiri::XML.parse(posts.to_xml)
      parsed.xpath("//posts/post/name").text.should ==  "Post"
    end
  end
end
