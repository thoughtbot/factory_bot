require 'spec_helper'

describe 'modifying traits in child factories' do
  before do
    define_model('User', gender: :string, age: :integer)
    FactoryGirl.define do
      factory :user do
        trait(:female) { gender 'Female' }
        trait(:young_female) do
          female
          age 17
        end

        factory :robot_user do
          trait(:female) { gender 'Female Robot' }
        end
      end
    end
  end

  describe 'an inherited factory which overwrites traits' do
    subject { FactoryGirl.build(:robot_user, :young_female) }

    its(:gender) { is_expected.to eq 'Female Robot' }

    context 'when the parent has been created before' do
      before(:each) { FactoryGirl.build(:user, :young_female) }

      its(:gender) { is_expected.to eq 'Female Robot' }
    end
  end

  describe 'a factory having a child factory which overwrites traits' do
    subject { FactoryGirl.build(:user, :young_female) }

    its(:gender) { is_expected.to eq 'Female' }

    context 'when the child has been created before' do
      before(:each) { FactoryGirl.build(:robot_user, :young_female) }

      its(:gender) { is_expected.to eq 'Female' }
    end
  end
end
