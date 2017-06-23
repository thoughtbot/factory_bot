require "spec_helper"

describe "Deprecate static attributes" do
  around do |example|
    old_warn = FactoryGirl.configuration.warn_on_static_attributes
    FactoryGirl.configuration.warn_on_static_attributes = true
    example.run
    FactoryGirl.configuration.warn_on_static_attributes = old_warn
  end

  it "warns that static usage is deprecated" do
    define_model("Comment", published_on: :date, user_id: :integer)
    define_model("User", name: :string, email: :string)

    ActiveSupport::Deprecation.expects(:warn).with(
      "Factory 'user' has the following static attributes:\n* name\n* email"
    ).once

    ActiveSupport::Deprecation.expects(:warn).with(
      "Factory 'comment' has the following static attributes:\n* published_on"
    ).once

    FactoryGirl.define do
      factory :comment do
        published_on Date.current
        user
      end

      factory :post

      factory :user do
        name "John Doe"
        email "john@example.com"
      end
    end
  end
end
