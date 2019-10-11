describe FactoryBot, "aliases" do
  it "aliases for an attribute should include the original attribute and a version suffixed with '_id'" do
    aliases = FactoryBot.aliases_for(:test)

    expect(aliases).to include(:test)
    expect(aliases).to include(:test_id)
  end

  it "aliases for a foreign key should include both the suffixed and un-suffixed variants" do
    aliases = FactoryBot.aliases_for(:test_id)

    expect(aliases).to include(:test)
    expect(aliases).to include(:test_id)
  end

  it "aliases for an attribute which starts with an underscore should not include a non-underscored version" do
    aliases = FactoryBot.aliases_for(:_id)

    expect(aliases).not_to include(:id)
  end
end

describe FactoryBot, "after defining an alias" do
  it "the list of aliases should include a variant with no suffix at all, and one with an '_id' suffix" do
    FactoryBot.aliases << [/(.*)_suffix/, '\1']
    aliases = FactoryBot.aliases_for(:test_suffix)

    expect(aliases).to include(:test)
    expect(aliases).to include(:test_suffix_id)
  end
end
