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

  it 'raises InvalidFactoryError containing factory name when a factory build raises RuntimeError' do
    define_model 'LintBuildFailOnRuntimeError', name: :string do
    end

    FactoryGirl.define do
      factory :lint_build_fail_on_runtime_error do
      end
    end

    FactoryGirl.stubs(:build).raises(RuntimeError)

    expect do
      FactoryGirl.lint
    end.to raise_error FactoryGirl::InvalidFactoryError, /lint_build_fail_on_runtime_error/
  end

  it 'raises InvalidFactoryError containing factory name when a factory build raises StandardError' do
    define_model 'LintBuildFailOnStandardError', name: :string do
    end

    FactoryGirl.define do
      factory :lint_build_fail_on_standard_error do
      end
    end

    FactoryGirl.stubs(:build).raises(StandardError)

    expect do
      FactoryGirl.lint
    end.to raise_error FactoryGirl::InvalidFactoryError, /lint_build_fail_on_standard_error/
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
end
