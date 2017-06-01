require 'spec_helper'

describe FactoryGirl::Strategy::Create do
  before do
    RSpec.configure do |config|
      config.mock_with :rspec do |mocks|
        mocks.verify_partial_doubles = false
      end
    end
  end

  after do
    RSpec.configure do |config|
      config.mock_with :rspec do |mocks|
        mocks.verify_partial_doubles = true
      end
    end
  end

  it_should_behave_like "strategy with association support", :create
  it_should_behave_like "strategy with callbacks", :after_build, :before_create, :after_create

  it "runs a custom create block" do
    evaluation_class = Class.new do
      def initialize
        @block_run = false
      end

      attr_reader :block_run

      def create(*instance)
        @block_run = true
      end
    end

    evaluation = evaluation_class.new
    allow(evaluation).to receive(:object)
    allow(evaluation).to receive(:notify)
    subject.result(evaluation)
    expect(evaluation.block_run).to be true
  end
end
