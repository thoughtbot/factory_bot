Then /^I should find the following for the last category:$/ do |table|
  table.hashes.first.each do |key, value|
    Category.last.attributes[key].to_s.should == value
  end
end

Before do
  Category.delete_all
end
