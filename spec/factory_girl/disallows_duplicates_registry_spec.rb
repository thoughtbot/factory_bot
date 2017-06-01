require "spec_helper"

describe FactoryGirl::Decorator::DisallowsDuplicatesRegistry do
  let(:registry) do
    double("registry", name: "Great thing", register: true)
  end

  subject { described_class.new(registry) }

  it "delegates #register to the registry when not registered" do
    allow(registry).to receive(:registered?).and_return false
    subject.register(:awesome, {})
    expect(registry).to have_received(:register).with(:awesome, {})
  end

  it "raises when attempting to #register a previously registered strategy" do
    allow(registry).to receive(:registered?).and_return true
    expect { subject.register(:same_name, {}) }.
      to raise_error(FactoryGirl::DuplicateDefinitionError, "Great thing already registered: same_name")
  end
end
