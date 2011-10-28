require 'spec_helper'

describe FactoryGirl::DefinitionProxy, "#add_attribute" do
  subject     { FactoryGirl::Definition.new }
  let(:proxy) { FactoryGirl::DefinitionProxy.new(subject) }

  it "raises if both a block and value are given" do
    expect {
      proxy.add_attribute(:something, "great") { "will raise!" }
    }.to raise_error(FactoryGirl::AttributeDefinitionError, "Both value and block given")
  end

  it "declares a static attribute on the factory" do
    proxy.add_attribute(:attribute_name, "attribute value")
    subject.should have_static_declaration(:attribute_name).with_value("attribute value")
  end

  it "declares a dynamic attribute on the factory" do
    attribute_value = lambda { "dynamic attribute" }
    proxy.add_attribute(:attribute_name, &attribute_value)
    subject.should have_dynamic_declaration(:attribute_name).with_value(attribute_value)
  end
end

describe FactoryGirl::DefinitionProxy, "#add_attribute when the proxy ignores attributes" do
  subject     { FactoryGirl::Definition.new }
  let(:proxy) { FactoryGirl::DefinitionProxy.new(subject, true) }

  it "raises if both a block and value are given" do
    expect {
      proxy.add_attribute(:something, "great") { "will raise!" }
    }.to raise_error(FactoryGirl::AttributeDefinitionError, "Both value and block given")
  end

  it "declares a static attribute on the factory" do
    proxy.add_attribute(:attribute_name, "attribute value")
    subject.should have_static_declaration(:attribute_name).ignored.with_value("attribute value")
  end

  it "declares a dynamic attribute on the factory" do
    attribute_value = lambda { "dynamic attribute" }
    proxy.add_attribute(:attribute_name, &attribute_value)
    subject.should have_dynamic_declaration(:attribute_name).ignored.with_value(attribute_value)
  end
end

describe FactoryGirl::DefinitionProxy, "#ignore" do
  subject     { FactoryGirl::Definition.new }
  let(:proxy) { FactoryGirl::DefinitionProxy.new(subject) }

  it "makes all attributes added ignored" do
    proxy.ignore do
      add_attribute(:attribute_name, "attribute value")
    end

    subject.should have_static_declaration(:attribute_name).ignored.with_value("attribute value")
  end
end

describe FactoryGirl::DefinitionProxy, "#method_missing" do
  subject     { FactoryGirl::Definition.new }
  let(:proxy) { FactoryGirl::DefinitionProxy.new(subject) }

  it "declares an implicit declaration without args or a block" do
    proxy.bogus
    subject.should have_implicit_declaration(:bogus).with_factory(subject)
  end

  it "declares an association when :factory is passed" do
    proxy.author :factory => :user
    subject.should have_association_declaration(:author).with_options(:factory => :user)
  end

  it "declares a static attribute" do
    proxy.attribute_name "attribute value"
    subject.should have_static_declaration(:attribute_name).with_value("attribute value")
  end

  it "declares a dynamic attribute" do
    attribute_value = lambda { "dynamic attribute" }
    proxy.attribute_name &attribute_value
    subject.should have_dynamic_declaration(:attribute_name).with_value(attribute_value)
  end
end

describe FactoryGirl::DefinitionProxy, "#sequence" do
  subject     { FactoryGirl::Definition.new }
  let(:proxy) { FactoryGirl::DefinitionProxy.new(subject) }

  before      { FactoryGirl::Sequence.stubs(:new) }

  it "creates a new sequence starting at 1" do
    proxy.sequence(:great)
    FactoryGirl::Sequence.should have_received(:new).with(:great, 1)
  end

  it "creates a new sequence with an overridden starting vaue" do
    proxy.sequence(:great, "C")
    FactoryGirl::Sequence.should have_received(:new).with(:great, "C")
  end

  it "creates a new sequence with a block" do
    sequence_block = Proc.new {|n| "user+#{n}@example.com" }
    proxy.sequence(:great, 1, &sequence_block)
    FactoryGirl::Sequence.should have_received(:new).with(:great, 1, &sequence_block)
  end
end

describe FactoryGirl::DefinitionProxy, "#association" do
  subject     { FactoryGirl::Definition.new }
  let(:proxy) { FactoryGirl::DefinitionProxy.new(subject) }

  it "declares an association" do
    proxy.association(:association_name)
    subject.should have_association_declaration(:association_name)
  end

  it "declares an association with options" do
    proxy.association(:association_name, { :name => "Awesome" })
    subject.should have_association_declaration(:association_name).with_options(:name => "Awesome")
  end
end

describe FactoryGirl::DefinitionProxy, "adding callbacks" do
  subject        { FactoryGirl::Definition.new }
  let(:proxy)    { FactoryGirl::DefinitionProxy.new(subject) }
  let(:callback) { lambda { "my awesome callback!" } }

  context "#after_build" do
    before { proxy.after_build(&callback) }
    it     { should have_callback(:after_build).with_block(callback) }
  end

  context "#after_create" do
    before { proxy.after_create(&callback) }
    it     { should have_callback(:after_create).with_block(callback) }
  end

  context "#after_stub" do
    before { proxy.after_stub(&callback) }
    it     { should have_callback(:after_stub).with_block(callback) }
  end
end

describe FactoryGirl::DefinitionProxy, "#to_create" do
  subject     { FactoryGirl::Definition.new }
  let(:proxy) { FactoryGirl::DefinitionProxy.new(subject) }

  it "accepts a block to run in place of #save!" do
    to_create_block = lambda {|record| record.persist }
    proxy.to_create(&to_create_block)
    subject.to_create.should == to_create_block
  end
end

describe FactoryGirl::DefinitionProxy, "#factory" do
  subject     { FactoryGirl::Definition.new }
  let(:proxy) { FactoryGirl::DefinitionProxy.new(subject) }

  it "without options" do
    proxy.factory(:child)
    proxy.child_factories.should include([:child, {}, nil])
  end

  it "with options" do
    proxy.factory(:child, { :awesome => true })
    proxy.child_factories.should include([:child, { :awesome => true }, nil])
  end

  it "with a block" do
    child_block = lambda { }
    proxy.factory(:child, {}, &child_block)
    proxy.child_factories.should include([:child, {}, child_block])
  end
end

describe FactoryGirl::DefinitionProxy, "#trait" do
  subject     { FactoryGirl::Definition.new }
  let(:proxy) { FactoryGirl::DefinitionProxy.new(subject) }

  it "declares a trait" do
    male_trait = Proc.new { gender("Male") }
    proxy.trait(:male, &male_trait)
    subject.should have_trait(:male).with_block(male_trait)
  end
end
