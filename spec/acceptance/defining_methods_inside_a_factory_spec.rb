require 'spec_helper'

describe 'defining methods inside FactoryGirl' do
  it 'raises with a meaningful message' do
    define_model('User')

    expect do
      FactoryGirl.define do
        factory :user do
          def generate_name
            'John Doe'
          end
        end
      end
    end.to raise_error FactoryGirl::MethodDefinitionError, /Defining methods in blocks \(trait or factory\) is not supported \(generate_name\)/
  end
end
