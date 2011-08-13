require 'spec_helper'

describe FactoryGirl::Attribute::Callback do
  before do
    @name  = :after_create
    @block = proc{ 'block' }
    @attr  = FactoryGirl::Attribute::Callback.new(@name, @block)
  end

  it "should have a name" do
    @attr.name.should == @name
  end

  it "should set its callback on a proxy" do
    proxy = stub("proxy", :add_callback => true)
    @attr.add_to(proxy)
    proxy.should have_received(:add_callback).with(@name, @block)
  end

  it "should convert names to symbols" do
    FactoryGirl::Attribute::Callback.new('name', nil).name.should == :name
  end
end
