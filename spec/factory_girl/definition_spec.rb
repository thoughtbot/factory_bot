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
  let(:list) { stub("declaration list", overridable: true) }
  before { FactoryGirl::DeclarationList.stubs(new: list) }

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
  its(:to_create) { should be_nil }

  it "returns the assigned value when given a block" do
    block = proc { nil }
    subject.to_create(&block)
    subject.to_create.should == block
  end
end

describe FactoryGirl::Definition, "#definition_list" do
  let(:female_trait) { FactoryGirl::Trait.new(:female) }
  let(:admin_trait)  { FactoryGirl::Trait.new(:admin) }
  let(:female_definition) { female_trait.definition }
  let(:admin_definition) { admin_trait.definition }

  before do
    subject.define_trait(female_trait)
    FactoryGirl.stubs(trait_by_name: admin_trait)
  end

  context "without base traits" do
    it "returns the definition without any traits" do
      subject.definition_list.should == [subject]
    end

    it "finds the correct definitions after appending" do
      subject.append_traits([:female])
      subject.definition_list.should == [subject, female_definition]
    end

    it "finds the correct definitions after inheriting" do
      subject.inherit_traits([:female])
      subject.definition_list.should == [female_definition, subject]
    end

    it "looks for the trait on FactoryGirl" do
      subject.append_traits([:female, :admin])
      subject.definition_list.should == [subject, female_definition, admin_definition]
    end
  end

  context "with base traits" do
    subject { FactoryGirl::Definition.new("my definition", [:female]) }

    it "returns the base traits and definition" do
      subject.definition_list.should == [female_definition, subject]
    end

    it "finds the correct definitions after appending" do
      subject.append_traits([:admin])
      subject.definition_list.should == [female_definition, subject, admin_definition]
    end

    it "finds the correct definitions after inheriting" do
      subject.inherit_traits([:admin])
      subject.definition_list.should == [female_definition, admin_definition, subject]
    end
  end
end
