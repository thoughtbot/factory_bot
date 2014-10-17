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

  it 'allows for custom linting validators' do
    validator_with_errors_class = Class.new do
      def initialize(factory)
        @factory = factory
      end

      def valid?
        false
      end

      def to_s
        "#{@factory.name}: foo, bar, baz"
      end
    end

    FactoryGirl.configuration.factory_linter = validator_with_errors_class

    define_model 'User'

    FactoryGirl.define do
      factory :user do
        factory :admin_user
      end
    end

    error_message = <<-ERROR_MESSAGE.strip
The following factories are invalid:

* user: foo, bar, baz
* admin_user: foo, bar, baz
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

  it 'raises when a factory is invalid' do
    class SlowFactoryLinter
      THRESHOLD = 1

      def initialize(factory)
        @factory = factory
        @generated_factory = time_factory_generation
      end

      def valid?
        factory_valid? && within_time_threshold?
      end

      def to_s
        "#{factory.name.to_s} (took #{generation_time}s to build)"
      end

      private

      def factory_valid?
        if generated_factory.respond_to?(:valid?)
          generated_factory.valid?
        else
          true
        end
      end

      def within_time_threshold?
        generation_time < THRESHOLD
      end

      attr_reader :factory, :generated_factory, :generation_time

      def time_factory_generation
        start_time = Time.now
        generated_factory = FactoryGirl.create(factory.name)
        end_time = Time.now
        @generation_time = end_time - start_time

        generated_factory
      end
    end

    FactoryGirl.configuration.factory_linter = SlowFactoryLinter

    Timecop.freeze Time.now
    define_model 'User', name: :string do
      before_save do
        Timecop.freeze 1.second.from_now
      end
    end

    FactoryGirl.define do
      factory :user
    end

    error_message = <<-ERROR_MESSAGE.strip
The following factories are invalid:

* user (took 1.0s to build)
    ERROR_MESSAGE

    expect do
      FactoryGirl.lint
    end.to raise_error FactoryGirl::InvalidFactoryError, error_message
  end
end
