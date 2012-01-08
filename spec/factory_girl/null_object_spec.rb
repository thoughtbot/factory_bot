require "spec_helper"

describe FactoryGirl::NullObject do
  its(:id)     { should be_nil }
  its(:age)    { should be_nil }
  its(:name)   { should be_nil }
  its(:admin?) { should be_nil }
end
