require 'spec_helper'

describe FactoryGirl::Proxy::Build do
  let(:instance)    { stub("built-instance") }
  let(:proxy_class) { stub("class", :new => instance) }

  subject { FactoryGirl::Proxy::Build.new(proxy_class) }

  it_should_behave_like "proxy with association support", FactoryGirl::Proxy::Create
  it_should_behave_like "proxy with standard getters and setters", :attribute_name, "attribute value!"
  it_should_behave_like "proxy with callbacks", :after_build
  it_should_behave_like "proxy with :method => :build",
    FactoryGirl::Proxy::Build

  describe "specifying method" do
    it "defaults to create" do
      subject.send(:get_method, nil).should == FactoryGirl::Proxy::Create
    end

    it "can specify create explicitly" do
      subject.send(:get_method, :create).should ==
        FactoryGirl::Proxy::Create
    end

    it "can specify build explicitly" do
      subject.send(:get_method, :build).should ==
        FactoryGirl::Proxy::Build
    end

    it "complains if method is unrecognized" do
      lambda { subject.send(:get_method, :froboznicate) }.
        should raise_error("unrecognized method froboznicate")
    end
  end

end
