require "spec_helper"

describe FactoryGirl::NullObject do
  let(:methods_to_respond_to)     { %w[id age name admin?] }
  let(:methods_to_not_respond_to) { %w[email date_of_birth title] }

  subject { FactoryGirl::NullObject.new(methods_to_respond_to) }

  it "responds to the given methods" do
    methods_to_respond_to.each do |method_name|
      expect(subject.__send__(method_name)).to be_nil
      expect(subject).to respond_to(method_name)
    end
  end

  it "does not respond to other methods" do
    methods_to_not_respond_to.each do |method_name|
      expect { subject.__send__(method_name) }.to raise_error(NoMethodError)
      expect(subject).not_to respond_to(method_name)
    end
  end
end
