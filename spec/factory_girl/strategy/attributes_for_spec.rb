require 'spec_helper'

describe FactoryGirl::Strategy::AttributesFor do
  let(:result)     { { name: "John Doe", gender: "Male", admin: false } }
  let(:evaluation) { stub("evaluation", hash: result) }

  it_should_behave_like "strategy without association support"

  it "returns the hash from the evaluation" do
    expect(subject.result(evaluation)).to eq result
  end

  it "does not run the to_create block" do
    expect do
      subject.result(evaluation)
    end.to_not raise_error
  end
end
