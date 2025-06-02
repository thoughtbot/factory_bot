describe "sequences are evaluated in the correct context" do
  before do
    define_class("User") do
      attr_accessor :id, :name

      def awesome
        "aw yeah"
      end
    end
  end

  it "builds a sequence calling sprintf correctly" do
    FactoryBot.define do
      factory :sequence_with_sprintf, class: User do
        sequence(:id) { |n| sprintf("foo%d", n) }
      end
    end

    expect(FactoryBot.build(:sequence_with_sprintf).id).to eq "foo1"
  end

  it "invokes the correct method on the instance" do
    FactoryBot.define do
      factory :sequence_with_public_method, class: User do
        sequence(:id) { public_method(:awesome).call }
      end
    end

    expect(FactoryBot.build(:sequence_with_public_method).id).to eq "aw yeah"
  end

  it "invokes a method with no arguments on the instance" do
    FactoryBot.define do
      factory :sequence_with_frozen, class: User do
        sequence(:id) { frozen? }
      end
    end

    expect(FactoryBot.build(:sequence_with_frozen).id).to be false
  end

  it "allows direct reference of a method in a sequence" do
    FactoryBot.define do
      factory :sequence_referencing_attribute_directly, class: User do
        sequence(:id) { |n| "#{awesome}#{n}" }
      end
    end
    expect(FactoryBot.build(:sequence_referencing_attribute_directly).id).to eq "aw yeah1"
  end

  context "with inherited factories" do
    it "uses the parent's sequenced attribute" do
      FactoryBot.define do
        factory :parent, class: User do
          sequence(:id) { |n| "id_#{n}" }
          factory :child, class: User
        end
      end

      parents = FactoryBot.build_list(:parent, 3)
      expect(parents[0].id).to eq "id_1"
      expect(parents[1].id).to eq "id_2"
      expect(parents[2].id).to eq "id_3"

      children = FactoryBot.build_list(:child, 3)
      expect(children[0].id).to eq "id_4"
      expect(children[1].id).to eq "id_5"
      expect(children[2].id).to eq "id_6"
    end

    it "invokes the parent's sequenced trait from within a child's inherited trait" do
      FactoryBot.define do
        sequence :global_seq
        factory :parent, class: User do
          trait :with_sequenced_id do
            sequence(:id) { |n| "id_#{n}" }
          end

          factory :child, class: User
        end
      end

      parent_ids = FactoryBot.build_list(:parent, 3, :with_sequenced_id).map(&:id)
      expect(parent_ids).to eq ["id_1", "id_2", "id_3"]

      child_ids = FactoryBot.build_list(:child, 3, :with_sequenced_id).map(&:id)
      expect(child_ids).to eq ["id_4", "id_5", "id_6"]
    end

    it "invokes the child's sequenced trait from within the child's own trait" do
      FactoryBot.define do
        sequence :global_sequence
        factory :parent, class: User do
          trait :with_sequenced_id do
            sequence(:id) { |n| "id_#{n}" }
          end

          factory :child, class: User, aliases: [:toddler, :teen] do
            sequence(:id) { |n| "id_#{n}" }
            trait :with_own_sequence do
              sequence(:id, 1000, aliases: [:woo_hoo, :woo_hoo_2]) { |n| "id_#{n}" }
            end
          end
        end
      end

      parents = FactoryBot.build_list(:parent, 3, :with_sequenced_id)
      expect(parents[0].id).to eq "id_1"
      expect(parents[1].id).to eq "id_2"
      expect(parents[2].id).to eq "id_3"

      children = FactoryBot.build_list(:child, 3)
      expect(children[0].id).to eq "id_1"
      expect(children[1].id).to eq "id_2"
      expect(children[2].id).to eq "id_3"

      children = FactoryBot.build_list(:child, 3, :with_sequenced_id, :with_own_sequence)
      expect(children[0].id).to eq "id_1000"
      expect(children[1].id).to eq "id_1001"
      expect(children[2].id).to eq "id_1002"
    end

    it "redefines a child's sequence" do
      FactoryBot.define do
        factory :parent, class: User do
          sequence(:id) { |n| "parent_#{n}" }

          factory :child, class: User do
            sequence(:id) { |n| "child_#{n}" }
          end
        end
      end

      parents = FactoryBot.build_list(:parent, 3)
      expect(parents[0].id).to eq "parent_1"
      expect(parents[1].id).to eq "parent_2"
      expect(parents[2].id).to eq "parent_3"

      children = FactoryBot.build_list(:child, 3)
      expect(children[0].id).to eq "child_1"
      expect(children[1].id).to eq "child_2"
      expect(children[2].id).to eq "child_3"
    end

    it "maintains context separation" do
      FactoryBot.define do
        sequence(:id) { |n| "global_#{n}" }

        factory :parent, class: User do
          sequence(:id) { |n| "parent_#{n}" }

          factory :child, class: User do
            sequence(:id) { |n| "child_#{n}" }
          end
        end

        factory :sibling, class: User do
          sequence(:id) { |n| "sibling_#{n}" }
        end
      end

      globals = FactoryBot.generate_list(:id, 3)
      expect(globals[0]).to eq "global_1"
      expect(globals[1]).to eq "global_2"
      expect(globals[2]).to eq "global_3"

      parents = FactoryBot.build_list(:parent, 3)
      expect(parents[0].id).to eq "parent_1"
      expect(parents[1].id).to eq "parent_2"
      expect(parents[2].id).to eq "parent_3"

      children = FactoryBot.build_list(:child, 3)
      expect(children[0].id).to eq "child_1"
      expect(children[1].id).to eq "child_2"
      expect(children[2].id).to eq "child_3"

      siblings = FactoryBot.build_list(:sibling, 3)
      expect(siblings[0].id).to eq "sibling_1"
      expect(siblings[1].id).to eq "sibling_2"
      expect(siblings[2].id).to eq "sibling_3"
    end
  end
end
