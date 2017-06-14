require 'spec_helper'

describe 'FactoryGirl.lint' do
  it 'raises when a factory is invalid' do
    define_model 'User', name: :string do
      validates :name, presence: true
    end

    define_model 'AlwaysValid'

    FactoryGirl.define do
      factory :user do
        factory :admin_user
      end

      factory :always_valid
    end

    error_message = <<-ERROR_MESSAGE.strip
The following factories are invalid:

* user - Validation failed: Name can't be blank (ActiveRecord::RecordInvalid)
* admin_user - Validation failed: Name can't be blank (ActiveRecord::RecordInvalid)
    ERROR_MESSAGE

    expect do
      FactoryGirl.lint
    end.to raise_error FactoryGirl::InvalidFactoryError, error_message
  end

  it 'does not raise when all factories are valid' do
    define_model 'User', name: :string do
      validates :name, presence: true
    end

    FactoryGirl.define do
      factory :user do
        name 'assigned'
      end
    end

    expect { FactoryGirl.lint }.not_to raise_error
  end

  it 'allows for selective linting' do
    define_model 'InvalidThing', name: :string do
      validates :name, presence: true
    end

    define_model 'ValidThing', name: :string

    FactoryGirl.define do
      factory :valid_thing
      factory :invalid_thing
    end

    expect do
      only_valid_factories = FactoryGirl.factories.reject do |factory|
        factory.name =~ /invalid/
      end

      FactoryGirl.lint only_valid_factories
    end.not_to raise_error
  end

  it "allows for explicit factories and additional options" do
    define_model "User", name: :string do
      validates :name, presence: true
    end

    FactoryGirl.define do
      factory :user do
        name "assigned"
      end
    end

    FactoryGirl.lint FactoryGirl.factories, validate_traits: true
  end

  it "allows for additional options without explicit factories" do
    define_model "User", name: :string do
      validates :name, presence: true
    end

    FactoryGirl.define do
      factory :user do
        name "assigned"
      end
    end

    FactoryGirl.lint validate_traits: true
  end

  describe "trait validation" do
    context "enabled" do
      it "raises if a trait produces an invalid object" do
        define_model "User", name: :string do
          validates :name, presence: true
        end

        FactoryGirl.define do
          factory :user do
            name "Yep"
            trait :unnamed do
              name nil
            end
          end
        end

        error_message = <<-ERROR_MESSAGE.strip
The following factories are invalid:

* user+unnamed - Validation failed: Name can't be blank (ActiveRecord::RecordInvalid)
        ERROR_MESSAGE

        expect do
          FactoryGirl.lint traits: true
        end.to raise_error FactoryGirl::InvalidFactoryError, error_message
      end

      it "does not raise if a trait produces a valid object" do
        define_model "User", name: :string do
          validates :name, presence: true
        end

        FactoryGirl.define do
          factory :user do
            name "Yep"
            trait :renamed do
              name "Yessir"
            end
          end
        end

        expect do
          FactoryGirl.lint traits: true
        end.not_to raise_error
      end
    end

    context "disabled" do
      it "does not raises if a trait produces an invalid object" do
        define_model "User", name: :string do
          validates :name, presence: true
        end

        FactoryGirl.define do
          factory :user do
            name "Yep"
            trait :unnamed do
              name nil
            end
          end
        end

        expect do
          FactoryGirl.lint traits: false
          FactoryGirl.lint
        end.not_to raise_error
      end
    end
  end

  describe "factory strategy for linting" do
    it "uses the requested strategy" do
      define_class "User" do
        attr_accessor :name

        def save!
          raise "expected :build strategy, #save! shouldn't be invoked"
        end
      end

      FactoryGirl.define do
        factory :user do
          name "Barbara"
        end
      end

      expect do
        FactoryGirl.lint strategy: :build
      end.not_to raise_error
    end

    it "uses the requested strategy during trait validation" do
      define_class "User" do
        attr_accessor :name

        def save!
          raise "expected :build strategy, #save! shouldn't be invoked"
        end
      end

      FactoryGirl.define do
        factory :user do
          name "Barbara"

          trait :male do
            name "Bob"
          end
        end
      end

      expect do
        FactoryGirl.lint traits: true, strategy: :build
      end.not_to raise_error
    end
  end
end
