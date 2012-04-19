require "spec_helper"

describe 'FactoryGirlStepHelpers::HumanHashToAttributeHash' do
  before do
    Object.any_instance.stubs(:World)
    require "factory_girl/step_definitions"
  end

  describe "#attributes" do
    context "without associations" do
      it "transforms keys to symbols " do
        subject({'name' => 'John', 'age' => '42'}).attributes.should == {:name => 'John', :age => '42'}
      end

      it "copes with an empty human_hash" do
        subject({}, []).attributes.should == {}
      end
    end

    context "with associations" do
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
          expect {
            actual = subject({'user' => 'name: John'}, post_associations).attributes
            actual[:user].should == User.find_by_name('John')
          }.to change(User, :count).by(1)
        }.to change { User.find_by_name('John') }.from(nil)
      end

      it "finds an associated entity by passed attributes" do
        john = User.create!(name: 'John')

        expect {
          actual = subject({'user' => 'name: John'}, post_associations).attributes
          actual[:user].should == john
        }.to_not change(User, :count)
      end
    end
  end

  def subject(human_hash, associations = [])
    FactoryGirlStepHelpers::HumanHashToAttributeHash.new(human_hash, associations)
  end
end

