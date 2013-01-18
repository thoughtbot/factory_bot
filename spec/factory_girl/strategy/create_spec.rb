require 'spec_helper'

describe FactoryGirl::Strategy::Create do
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
    evaluation.stubs(object: nil, notify: nil)
    subject.result(evaluation)
    expect(evaluation.block_run).to be_true
  end
end
