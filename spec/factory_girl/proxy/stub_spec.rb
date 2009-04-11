require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper'))

describe Factory::Proxy::Stub do
  before do
    @proxy = Factory::Proxy::Stub.new(@class)
  end

  describe "when asked to associate with another factory" do
    before do
      stub(Factory).create
      @proxy.associate(:owner, :user, {})
    end

    it "should not set a value for the association" do
      @proxy.result.owner.should be_nil
    end
  end

  it "should return nil when building an association" do
    @proxy.association(:user).should be_nil
  end

  it "should not call Factory.create when building an association" do
    mock(Factory).create.never
    @proxy.association(:user).should be_nil
  end

  it "should always return nil when building an association" do
    @proxy.set(:association, 'x')
    @proxy.association(:user).should be_nil
  end

  it "should return a mock object when asked for the result" do
    @proxy.result.should be_kind_of(Object)
  end

  describe "after setting an attribute" do
    before do
      @proxy.set(:attribute, 'value')
    end

    it "should add a stub to the resulting object" do
      @proxy.attribute.should == 'value'
    end

    it "should return that value when asked for that attribute" do
      @proxy.get(:attribute).should == 'value'
    end
  end

  it "should define a setter even if attribute= is defined" do
    @proxy.set('attribute', nil)
    lambda { @proxy.set('age', 18) }.should_not raise_error
  end
end
