require 'spec_helper'

describe FactoryGirl::Callback do
  let(:name)  { :after_create }
  let(:block) { proc { "block" } }
  let(:proxy) { stub("proxy") }

  subject     { FactoryGirl::Callback.new(name, block) }

  its(:name)  { should == name }
end

describe FactoryGirl::Callback, "with a string name" do
  subject    { FactoryGirl::Callback.new("name", nil) }
  its(:name) { should == :name }
end
