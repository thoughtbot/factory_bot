require 'spec_helper'

describe FactoryGirl::Declaration::Implicit do
  context "using variable instead of symbol name" do
    let(:name) { :first_name }
    let(:first) { FactoryGirl::Declaration::Implicit.new(name) }
    subject { first == :some_symbol }
    it "raise error" do
      expect { subject }.to raise_error(NoMethodError,
                                        /symbol for factory name/)
    end
  end
end
