require "spec_helper"

describe FactoryWoman::Definition do
  it { should delegate(:declare_attribute).to(:declarations) }
  it { should delegate(:attributes).to(:declarations).as(:attribute_list) }
end

describe FactoryWoman::Definition, "with a name" do
  let(:name) { :"great name" }
  subject    { FactoryWoman::Definition.new(name) }

  it "creates a new attribute list with the name passed" do
    FactoryWoman::DeclarationList.stubs(:new)
    subject
    FactoryWoman::DeclarationList.should have_received(:new).with(name)
  end
end

describe FactoryWoman::Definition, "#overridable" do
  let(:list) { stub("declaration list", :overridable => true) }
  before { FactoryWoman::DeclarationList.stubs(:new => list) }

  it "sets the declaration list as overridable" do
    subject.overridable.should == subject
    list.should have_received(:overridable).once
  end
end

describe FactoryWoman::Definition, "defining traits" do
  let(:trait_1) { stub("trait") }
  let(:trait_2) { stub("trait") }

  it "maintains a list of traits" do
    subject.define_trait(trait_1)
    subject.define_trait(trait_2)
    subject.defined_traits.should == [trait_1, trait_2]
  end
end

describe FactoryWoman::Definition, "adding callbacks" do
  let(:callback_1) { stub("callback") }
  let(:callback_2) { stub("callback") }

  it "maintains a list of callbacks" do
    subject.add_callback(callback_1)
    subject.add_callback(callback_2)
    subject.callbacks.should == [callback_1, callback_2]
  end
end

describe FactoryWoman::Definition, "#to_create" do
  its(:to_create) { should be_nil }

  it "returns the assigned value when given a block" do
    block = proc { nil }
    subject.to_create(&block)
    subject.to_create.should == block
  end
end

describe FactoryWoman::Definition, "#traits" do
  let(:female_trait) { stub("female trait", :name => :female) }
  let(:admin_trait)  { stub("admin trait", :name => :admin) }

  before do
    subject.define_trait(female_trait)
    FactoryWoman.stubs(:trait_by_name => admin_trait)
  end

  its(:traits) { should be_empty }

  it "finds the correct traits after inheriting" do
    subject.inherit_traits([:female])
    subject.traits.should == [female_trait]
  end

  it "looks for the trait on FactoryWoman" do
    subject.inherit_traits([:female, :admin])
    subject.traits.should == [admin_trait, female_trait]
  end
end
