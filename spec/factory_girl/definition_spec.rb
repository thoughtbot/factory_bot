require "spec_helper"

describe FactoryGirl::Definition do
  it { should delegate(:declare_attribute).to(:declarations) }
  it { should delegate(:attributes).to(:declarations).as(:attribute_list) }
end

describe FactoryGirl::Definition, "with a name" do
  let(:name) { :"great name" }
  subject    { FactoryGirl::Definition.new(name) }

  it "creates a new attribute list with the name passed" do
    FactoryGirl::DeclarationList.stubs(:new)
    subject
    FactoryGirl::DeclarationList.should have_received(:new).with(name)
  end
end

describe FactoryGirl::Definition, "#overridable" do
  let(:list) { stub("declaration list", :overridable => true) }
  before { FactoryGirl::DeclarationList.stubs(:new => list) }

  it "sets the declaration list as overridable" do
    subject.overridable.should == subject
    list.should have_received(:overridable).once
  end
end

describe FactoryGirl::Definition, "defining traits" do
  let(:trait_1) { stub("trait") }
  let(:trait_2) { stub("trait") }

  it "maintains a list of traits" do
    subject.define_trait(trait_1)
    subject.define_trait(trait_2)
    subject.defined_traits.should == [trait_1, trait_2]
  end
end

describe FactoryGirl::Definition, "adding callbacks" do
  let(:callback_1) { stub("callback") }
  let(:callback_2) { stub("callback") }

  it "maintains a list of callbacks" do
    subject.add_callback(callback_1)
    subject.add_callback(callback_2)
    subject.callbacks.should == [callback_1, callback_2]
  end
end

describe FactoryGirl::Definition, "#to_create" do
  its(:to_create) { should be_a(Proc) }

  it "calls save! on the object when run" do
    instance = stub("model instance", :save! => true)
    subject.to_create[instance]
    instance.should have_received(:save!).once
  end

  it "returns the assigned value when given a block" do
    block = proc { nil }
    subject.to_create(&block)
    subject.to_create.should == block
  end
end

describe FactoryGirl::Definition, "#traits" do
  let(:female_trait) { stub("female trait", :name => :female) }
  let(:admin_trait)  { stub("admin trait", :name => :admin) }

  before do
    subject.define_trait(female_trait)
    FactoryGirl.stubs(:trait_by_name => admin_trait)
  end

  its(:traits) { should be_empty }

  it "finds the correct traits after inheriting" do
    subject.inherit_traits([:female])
    subject.traits.should == [female_trait]
  end

  it "looks for the trait on FactoryGirl" do
    subject.inherit_traits([:female, :admin])
    subject.traits.should == [admin_trait, female_trait]
  end
end
