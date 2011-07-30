require 'spec_helper'

describe FactoryGirl::Attribute do
  before do
    @name  = :user
    @attr  = FactoryGirl::Attribute.new(@name)
  end

  it "should have a name" do
    @attr.name.should == @name
  end

  it "isn't an association" do
    @attr.should_not be_association
  end

  it "should do nothing when being added to a proxy" do
    @proxy = "proxy"
    stub(@proxy).set
    @attr.add_to(@proxy)
    @proxy.should have_received.set.never
  end

  it "should raise an error when defining an attribute writer" do
    error_message = %{factory_girl uses 'f.test value' syntax rather than 'f.test = value'}
    lambda {
      FactoryGirl::Attribute.new('test=')
    }.should raise_error(FactoryGirl::AttributeDefinitionError, error_message)
  end

  it "should convert names to symbols" do
    FactoryGirl::Attribute.new('name').name.should == :name
  end

  it "should return nil when is compared with a non-attribute object" do
    (@attr <=> "foo").should == nil
  end

  it "should use priority to perform comparisons" do
    attr2 = FactoryGirl::Attribute.new('name')
    (@attr <=> attr2).should == 0
  end
end
