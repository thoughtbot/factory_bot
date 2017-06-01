require 'spec_helper'

describe FactoryGirl::Attribute::Association do
  let(:name)        { :author }
  let(:factory)     { :user }
  let(:overrides)   { { first_name: "John" } }
  let(:association) { double("association") }

  subject { FactoryGirl::Attribute::Association.new(name, factory, overrides) }
  before do
    RSpec.configure do |config|
      config.mock_with :rspec do |mocks|
        # FactoryGirl::Attribute::Association does not explicitly define an
        # `association` instance method, so when we stub it out below,
        # rspec-mock complains that it can't find the method.
        #
        # Therefore, temporarily turn off this feature.
        mocks.verify_partial_doubles = false
      end
    end
    allow(subject).to receive(:association).and_return association
  end

  after do
    RSpec.configure do |config|
      config.mock_with :rspec do |mocks|
        mocks.verify_partial_doubles = true
      end
    end
  end

  it         { should be_association }
  its(:name) { should eq name }

  it "builds the association when calling the proc" do
    expect(subject.to_proc.call).to eq association
  end

  it "builds the association when calling the proc" do
    subject.to_proc.call
    expect(subject).to have_received(:association).with(factory, overrides)
  end
end

describe FactoryGirl::Attribute::Association, "with a string name" do
  subject    { FactoryGirl::Attribute::Association.new("name", :user, {}) }
  its(:name) { should eq :name }
end
