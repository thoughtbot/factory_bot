require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Factory::Proxy do
  before do
    @proxy = Factory::Proxy.new(Class.new)
  end

  it "should do nothing when asked to set an attribute to a value" do
    lambda { @proxy.set(:name, 'a name') }.should_not raise_error
  end

  it "should return nil when asked for an attribute" do
    @proxy.get(:name).should be_nil
  end

  it "should call get for a missing method" do
    mock(@proxy).get(:name) { "it's a name" }
    @proxy.name.should == "it's a name"
  end

  it "should do nothing when asked to associate with another factory" do
    lambda { @proxy.associate(:owner, :user, {}) }.should_not raise_error
  end

  it "should raise an error when asked for the result" do
    lambda { @proxy.result }.should raise_error(NotImplementedError)
  end
end
