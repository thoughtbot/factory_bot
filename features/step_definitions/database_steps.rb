Then /^I should find the following for the last category:$/ do |table|
  table.hashes.first.each do |key, value|
    expect(Category.last.attributes[key].to_s).to eq value
  end
end

Before do
  Category.delete_all
end
