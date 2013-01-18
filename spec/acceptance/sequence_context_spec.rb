require 'spec_helper'

describe 'sequences are evaluated in the correct context' do
  before do
    define_class("User") do
      attr_accessor :id

      def awesome
        'aw yeah'
      end
    end
  end

  it 'builds a sequence calling sprintf correctly' do
    FactoryGirl.define do
      factory :sequence_with_sprintf, class: User do
        sequence(:id) {|n| sprintf("foo%d", n) }
      end
    end

    expect(FactoryGirl.build(:sequence_with_sprintf).id).to eq 'foo1'
  end

  it 'invokes the correct method on the instance' do
    FactoryGirl.define do
      factory :sequence_with_public_method, class: User do
        sequence(:id) {|n| public_method(:awesome).call }
      end
    end

    expect(FactoryGirl.build(:sequence_with_public_method).id).to eq 'aw yeah'
  end

  it 'invokes a method with no arguments on the instance' do
    FactoryGirl.define do
      factory :sequence_with_frozen, class: User do
        sequence(:id) {|n| frozen? }
      end
    end

    expect(FactoryGirl.build(:sequence_with_frozen).id).to be_false
  end

  it 'allows direct reference of a method in a sequence' do
    FactoryGirl.define do
      factory :sequence_referencing_attribute_directly, class: User do
        sequence(:id) {|n| "#{awesome}#{n}" }
      end
    end
    expect(FactoryGirl.build(:sequence_referencing_attribute_directly).id).to eq 'aw yeah1'
  end
end
