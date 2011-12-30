require "spec_helper"

describe FactoryGirl::Proxy::Build do
  it_should_behave_like "proxy with association support", FactoryGirl::Proxy::Create
  it_should_behave_like "proxy with callbacks", :after_build
  it_should_behave_like "proxy with :method => :build", FactoryGirl::Proxy::Build
end
