require 'spec_helper'

describe FactoryGirl::Attribute::Dynamic do
  before do
    @name  = :first_name
    @block = lambda { 'value' }
    @attr  = FactoryGirl::Attribute::Dynamic.new(@name, @block)
  end

  it "should have a name" do
    @attr.name.should == @name
  end

  it "should call the block to set a value" do
    @proxy = stub("proxy", :set => nil)
    @attr.add_to(@proxy)
    @proxy.should have_received(:set).with(@name, 'value')
  end

  it "should yield the proxy to the block when adding its value to a proxy" do
    @block = lambda {|a| a }
    @attr  = FactoryGirl::Attribute::Dynamic.new(:user, @block)
    @proxy = stub("proxy", :set => nil)
    @attr.add_to(@proxy)
    @proxy.should have_received(:set).with(:user, @proxy)
  end

  it "evaluates the block with in the context of the proxy without an argument" do
    result = 'other attribute value'
    @block = lambda { other_attribute }
    @attr  = FactoryGirl::Attribute::Dynamic.new(:user, @block)
    @proxy = stub("proxy", :set => nil, :other_attribute => result)
    @attr.add_to(@proxy)
    @proxy.should have_received(:set).with(:user, result)
  end

  it "should raise an error when defining an attribute writer" do
    lambda {
      FactoryGirl::Attribute::Dynamic.new('test=', nil)
    }.should raise_error(FactoryGirl::AttributeDefinitionError)
  end

  it "should raise an error when returning a sequence" do
    Factory.stubs(:sequence => FactoryGirl::Sequence.new(:email))
    block = lambda { Factory.sequence(:email) }
    attr = FactoryGirl::Attribute::Dynamic.new(:email, block)
    proxy = stub("proxy")
    lambda {
      attr.add_to(proxy)
    }.should raise_error(FactoryGirl::SequenceAbuseError)
  end

  it "should convert names to symbols" do
    FactoryGirl::Attribute::Dynamic.new('name', nil).name.should == :name
  end
end
