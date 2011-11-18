require 'spec_helper'

describe FactoryWoman::Proxy::Build do
  let(:instance)    { stub("built-instance") }
  let(:proxy_class) { stub("class", :new => instance) }

  subject { FactoryWoman::Proxy::Build.new(proxy_class) }

  it_should_behave_like "proxy with association support", FactoryWoman::Proxy::Create
  it_should_behave_like "proxy with standard getters and setters", :attribute_name, "attribute value!"
  it_should_behave_like "proxy with callbacks", :after_build
  it_should_behave_like "proxy with :method => :build", FactoryWoman::Proxy::Build
end
