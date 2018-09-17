describe "calling methods on the model instance" do
  before do
    define_model("User", age: :integer, age_copy: :integer) do
      def age
        read_attribute(:age) || 18
      end
    end

    FactoryBot.define do
      factory :user do
        age_copy { age }
      end
    end
  end

  context "without the attribute being overridden" do
    it "returns the correct value from the instance" do
      expect(FactoryBot.build(:user).age_copy).to eq 18
    end

    it "returns nil during attributes_for" do
      expect(FactoryBot.attributes_for(:user)[:age_copy]).to be_nil
    end

    it "doesn't instantiate a record with attributes_for" do
      allow(User).to receive(:new)
      FactoryBot.attributes_for(:user)
      expect(User).to_not have_received(:new)
    end
  end

  context "with the attribute being overridden" do
    it "uses the overridden value" do
      expect(FactoryBot.build(:user, age_copy: nil).age_copy).to be_nil
    end

    it "uses the overridden value during attributes_for" do
      expect(FactoryBot.attributes_for(:user, age_copy: 25)[:age_copy]).to eq 25
    end
  end

  context "with the referenced attribute being overridden" do
    it "uses the overridden value" do
      expect(FactoryBot.build(:user, age: nil).age_copy).to be_nil
    end

    it "uses the overridden value during attributes_for" do
      expect(FactoryBot.attributes_for(:user, age: 25)[:age_copy]).to eq 25
    end
  end
end
