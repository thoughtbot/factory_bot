describe FactoryBot, "aliases" do
  it "aliases for an attribute should include the original attribute and a version suffixed with '_id'" do
    aliases = FactoryBot.aliases_for(:test)

    expect(aliases).to include(:test)
    expect(aliases).to include(:test_id)
  end

  it "aliases for a foreign key should include the un-suffixed attribute name" do
    aliases = FactoryBot.aliases_for(:test_id)

    expect(aliases).to include(:test)
  end

  it "aliases for a foreign key should include the original attribute name" do
    aliases = FactoryBot.aliases_for(:test_id)

    expect(aliases).to include(:test_id)
  end

  it "aliases for an attribute starting with an underscore should not include a non-underscored version" do
    aliases = FactoryBot.aliases_for(:_id)

    expect(aliases).not_to include(:id)
  end
end

describe FactoryBot, "after defining an alias" do
  it "the list of aliases should include an un-suffixed equivalent" do
    FactoryBot.aliases << [/(.*)_suffix/, '\1']
    aliases = FactoryBot.aliases_for(:test_suffix)

    expect(aliases).to include(:test)
  end

  it "the list of aliases should include the original name plus an '_id' suffix" do
    FactoryBot.aliases << [/(.*)_suffix/, '\1']
    aliases = FactoryBot.aliases_for(:test_suffix)

    expect(aliases).to include(:test_suffix_id)
  end
end
