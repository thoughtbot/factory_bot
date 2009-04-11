require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Factory::Attribute do
  before do
    @name  = :user
    @attr  = Factory::Attribute.new(@name)
  end

  it "should have a name" do
    @attr.name.should == @name
  end

  it "should do nothing when being added to a proxy" do
    @proxy = "proxy"
    stub(@proxy).set
    @attr.add_to(@proxy)
    @proxy.should have_received.set.never
  end

  it "should raise an error when defining an attribute writer" do
    lambda {
      Factory::Attribute.new('test=')
    }.should raise_error(Factory::AttributeDefinitionError)
  end

  it "should convert names to symbols" do
    Factory::Attribute.new('name').name.should == :name
  end
end
