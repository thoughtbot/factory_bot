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

* user
* admin_user
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

  it 'supports models which do not respond to #valid?' do
    define_class 'Thing'

    FactoryGirl.define do
      factory :thing
    end

    expect(Thing.new).not_to respond_to(:valid?)
    expect { FactoryGirl.lint }.not_to raise_error
  end

  it 'allows for selective linting' do
    define_class 'InvalidThing' do
      def valid?
        false
      end
    end

    define_class 'ValidThing' do
      def valid?
        true
      end
    end

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
end
