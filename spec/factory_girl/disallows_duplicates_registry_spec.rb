require "spec_helper"

describe FactoryGirl::DisallowsDuplicatesRegistry do
  let(:registry) { stub("registry", name: "Great thing", register: true, find: true, each: true, clear: true, registered?: true, :[] => true) }

  subject { FactoryGirl::DisallowsDuplicatesRegistry.new(registry) }

  it "delegates #each to the registry" do
    block = -> {}
    subject.each(block)
    registry.should have_received(:each).with(block)
  end

  it "delegates #registered? to the registry" do
    subject.registered?(:great_name)
    registry.should have_received(:registered?).with(:great_name)
  end

  it "delegates #clear to the registry" do
    subject.clear
    registry.should have_received(:clear)
  end

  it "delegates #find to the registry" do
    subject.find(:awesome)
    registry.should have_received(:find).with(:awesome)
  end

  it "delegates #[] to the registry" do
    subject[:awesome]
    registry.should have_received(:[]).with(:awesome)
  end

  it "delegates #register to the registry when not registered" do
    registry.stubs(registered?: false)
    subject.register(:awesome, {})
    registry.should have_received(:register).with(:awesome, {})
  end

  it "raises when attempting to #register a previously registered strategy" do
    expect { subject.register(:same_name, {}) }.
      to raise_error(FactoryGirl::DuplicateDefinitionError, "Great thing already registered: same_name")
  end
end
