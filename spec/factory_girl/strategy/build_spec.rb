require "spec_helper"

describe FactoryGirl::Strategy::Build do
  it_should_behave_like "strategy with association support", :create
  it_should_behave_like "strategy with callbacks", :after_build
  it_should_behave_like "strategy with strategy: :build", :build
end
