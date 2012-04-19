require "spec_helper"

describe "human hash to attribute hash converting" do
  before do
    Object.any_instance.stubs(:World)
    require "factory_girl/step_definitions"
  end

  subject do
    world_class = Class.new
    world_class.send(:include, FactoryGirlStepHelpers)
    world_class.new
  end

  context "without activerecord associations" do
    it "transforms keys to symbols " do
      actual = subject.convert_human_hash_to_attribute_hash('name' => 'John', 'age' => '42')
      actual.should == { :name => 'John', :age => '42' }
    end

    it "copes with an empty human_hash" do
      subject.convert_human_hash_to_attribute_hash({}).should == {}
    end
  end

  context "with activerecord associations" do
    before do
      define_model('User', name: :string) do
        has_many :posts
      end

      define_model('Post', title: :string, user_id: :integer) do
        belongs_to :user
      end

      FactoryGirl.define do
        factory :post do
          title "Through the Looking Glass"
          user
        end

        factory :user do
          name "John Doe"
        end
      end
    end

    let(:post_associations) { FactoryGirl.factory_by_name(:post).associations }

    it "creates an associated entity if there is no suitable" do
      expect {
        actual = subject.convert_human_hash_to_attribute_hash({'user' => 'name: John'},
                                                              post_associations)
        actual[:user].should == User.find_by_name('John')
      }.to change { User.find_by_name('John') }.from(nil)
    end

    it "finds an associated entity by passed attributes" do
      john = User.create!(name: 'John')

      expect {
        actual = subject.convert_human_hash_to_attribute_hash({'user' => 'name: John'},
                                                              post_associations)
        actual[:user].should == john
      }.to_not change(User, :count)
    end
  end
end

