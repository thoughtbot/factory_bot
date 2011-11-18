require 'spec_helper'

describe FactoryWoman, "aliases" do
  context "aliases for an attribute" do
    subject { FactoryWoman.aliases_for(:test) }
    it      { should include(:test) }
    it      { should include(:test_id) }
  end

  context "aliases for a foreign key" do
    subject { FactoryWoman.aliases_for(:test_id) }
    it      { should include(:test) }
    it      { should include(:test_id) }
  end

  context "aliases for an attribute starting with an underscore" do
    subject { FactoryWoman.aliases_for(:_id) }
    it      { should_not include(:id) }
  end
end

describe Factory, "after defining an alias" do
  before do
    Factory.alias(/(.*)_suffix/, '\1')
  end

  subject { FactoryWoman.aliases_for(:test_suffix) }

  it { should include(:test) }
  it { should include(:test_suffix_id) }
end
