require "spec_helper"

describe "calling methods on the model instance" do
  before do
    define_model('User', age: :integer, age_copy: :integer) do
      def age
        read_attribute(:age) || 18
      end
    end

    FactoryGirl.define do
      factory :user do
        age_copy { age }
      end
    end
  end

  context "without the attribute being overridden" do
    it "returns the correct value from the instance" do
      expect(FactoryGirl.build(:user).age_copy).to eq 18
    end

    it "returns nil during attributes_for" do
      expect(FactoryGirl.attributes_for(:user)[:age_copy]).to be_nil
    end

    it "doesn't instantiate a record with attributes_for" do
      User.stubs(:new)
      FactoryGirl.attributes_for(:user)
      expect(User).to have_received(:new).never
    end
  end

  context "with the attribute being overridden" do
    it "uses the overridden value" do
      expect(FactoryGirl.build(:user, age_copy: nil).age_copy).to be_nil
    end

    it "uses the overridden value during attributes_for" do
      expect(FactoryGirl.attributes_for(:user, age_copy: 25)[:age_copy]).to eq 25
    end
  end

  context "with the referenced attribute being overridden" do
    it "uses the overridden value" do
      expect(FactoryGirl.build(:user, age: nil).age_copy).to be_nil
    end

    it "uses the overridden value during attributes_for" do
      expect(FactoryGirl.attributes_for(:user, age: 25)[:age_copy]).to eq 25
    end
  end
end
