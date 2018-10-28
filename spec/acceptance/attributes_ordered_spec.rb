describe "a generated attributes hash where order matters" do
  include FactoryBot::Syntax::Methods

  before do
    define_model("ParentModel", static:           :integer,
                                evaluates_first:  :integer,
                                evaluates_second: :integer,
                                evaluates_third:  :integer)

    FactoryBot.define do
      factory :parent_model do
        evaluates_first  { static }
        evaluates_second { evaluates_first }
        evaluates_third  { evaluates_second }

        factory :child_model do
          static { 1 }
        end
      end

      factory :without_parent, class: ParentModel do
        evaluates_first   { static }
        evaluates_second  { evaluates_first }
        evaluates_third   { evaluates_second }
        static { 1 }
      end
    end
  end

  context "factory with a parent" do
    subject { FactoryBot.build(:child_model) }

    it "assigns attributes in the order they're defined" do
      expect(subject[:evaluates_first]).to eq 1
      expect(subject[:evaluates_second]).to eq 1
      expect(subject[:evaluates_third]).to eq 1
    end
  end

  context "factory without a parent" do
    subject { FactoryBot.build(:without_parent) }

    it "assigns attributes in the order they're defined without a parent class" do
      expect(subject[:evaluates_first]).to eq 1
      expect(subject[:evaluates_second]).to eq 1
      expect(subject[:evaluates_third]).to eq 1
    end
  end
end
