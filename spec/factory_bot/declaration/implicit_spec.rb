require 'spec_helper'

describe FactoryBot::Declaration::Implicit do
  let(:name)        { :author }
  let(:declaration) { FactoryBot::Declaration::Implicit.new(name) }
  subject           { declaration.to_attributes.first }

  context "with a known factory" do
    before do
      allow(FactoryBot.factories).to receive(:registered?).and_return true
    end

    it { should be_association }
    its(:factory) { should eq name }
  end

  context "with a known sequence" do
    before do
      allow(FactoryBot.sequences).to receive(:registered?).and_return true
    end

    it { should_not be_association }
    it { should be_a(FactoryBot::Attribute::Sequence) }
  end
end
