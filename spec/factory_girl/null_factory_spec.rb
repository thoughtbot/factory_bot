require "spec_helper"

describe FactoryWoman::NullFactory do
  it { should delegate(:defined_traits).to(:definition) }
  it { should delegate(:callbacks).to(:definition) }
  it { should delegate(:attributes).to(:definition) }

  its(:compile)          { should be_nil }
  its(:default_strategy) { should be_nil }
  its(:class_name)       { should be_nil }
  its(:attributes)       { should be_an_instance_of(FactoryWoman::AttributeList) }
end
