require "spec_helper"

describe FactoryGirl::Strategy::Build do
  it_should_behave_like "strategy with association support", FactoryGirl::Strategy::Create
  it_should_behave_like "strategy with callbacks", :after_build
  it_should_behave_like "strategy with strategy: :build", FactoryGirl::Strategy::Build
end
