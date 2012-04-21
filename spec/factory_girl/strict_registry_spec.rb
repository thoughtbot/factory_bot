require "spec_helper"

describe FactoryGirl::StrictRegistry do
  let(:registry) { stub("registry", name: "Great thing", register: true, find: true, each: true, registered?: true, clear: true) }

  subject { FactoryGirl::StrictRegistry.new(registry) }

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

  it "raises when trying to find an unregistered object" do
    registry.stubs(registered?: false)
    expect { subject.find(:bogus) }.to raise_error(ArgumentError, "Great thing not registered: bogus")
  end

  it "doesn't allow a duplicate name" do
    expect { 2.times { subject.register(:same_name, {}) } }.
      to raise_error(FactoryGirl::DuplicateDefinitionError, "Great thing already registered: same_name")
  end
end
