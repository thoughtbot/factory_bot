require 'spec_helper'

describe FactoryBot::Strategy::Create do
  it_should_behave_like "strategy with association support", :create
  it_should_behave_like "strategy with callbacks", :after_build, :before_create, :after_create

  it "runs a custom create block" do
    evaluation = double(
      "evaluation",
      object: nil,
      notify: nil,
      create: nil,
    )

    subject.result(evaluation)

    expect(evaluation).to have_received(:create).once
  end
end
