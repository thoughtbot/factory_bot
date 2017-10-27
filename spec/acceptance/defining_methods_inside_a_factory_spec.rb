require 'spec_helper'

describe 'defining methods inside FactoryBot' do
  it 'raises with a meaningful message' do
    define_model('User')

    expect do
      FactoryBot.define do
        factory :user do
          def generate_name
            'a83k35h9 Ths9ddms'
          end
        end
      end
    end.to raise_error FactoryBot::MethodDefinitionError, /Defining methods in blocks \(trait or factory\) is not supported \(generate_name\)/
  end
end
