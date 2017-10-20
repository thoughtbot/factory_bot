require 'spec_helper'

describe FactoryBot, "aliases" do
  context "aliases for an attribute" do
    subject { FactoryBot.aliases_for(:test) }
    it      { should include(:test) }
    it      { should include(:test_id) }
  end

  context "aliases for a foreign key" do
    subject { FactoryBot.aliases_for(:test_id) }
    it      { should include(:test) }
    it      { should include(:test_id) }
  end

  context "aliases for an attribute starting with an underscore" do
    subject { FactoryBot.aliases_for(:_id) }
    it      { should_not include(:id) }
  end
end

describe FactoryBot, "after defining an alias" do
  before do
    FactoryBot.aliases << [/(.*)_suffix/, '\1']
  end

  subject { FactoryBot.aliases_for(:test_suffix) }

  it { should include(:test) }
  it { should include(:test_suffix_id) }
end
