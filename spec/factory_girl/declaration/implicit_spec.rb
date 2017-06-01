require 'spec_helper'

describe FactoryGirl::Declaration::Implicit do
  let(:name)        { :author }
  let(:declaration) { FactoryGirl::Declaration::Implicit.new(name) }
  subject           { declaration.to_attributes.first }

  context "with a known factory" do
    before do
      allow(FactoryGirl.factories).to receive(:registered?).and_return true
    end

    it { should be_association }
    its(:factory) { should eq name }
  end

  context "with a known sequence" do
    before do
      allow(FactoryGirl.sequences).to receive(:registered?).and_return true
    end

    it { should_not be_association }
    it { should be_a(FactoryGirl::Attribute::Sequence) }
  end
end
