require 'spec_helper'

describe FactoryGirl::Proxy::Build do
  let(:instance)    { stub("built-instance") }
  let(:proxy_class) { stub("class", :new => instance) }

  subject { FactoryGirl::Proxy::Build.new(proxy_class) }

  it_should_behave_like "proxy with association support", FactoryGirl::Proxy::Create
  it_should_behave_like "proxy with standard getters and setters", :attribute_name, "attribute value!"
  it_should_behave_like "proxy with callbacks", :after_build
  it_should_behave_like "proxy with :method => :build", FactoryGirl::Proxy::Build
end
