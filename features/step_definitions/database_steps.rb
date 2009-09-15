Then /^I should find the following for the last post:$/ do |table|
  last_post = Post.last or raise "No posts exist"
  attributes = table.rows.inject({}) {|res, (key, value)| res.merge(key => value) }
  attributes.each do |key, value|
    last_post.attributes[key].should == value
  end
end

Then /^there should be (\d+) posts$/ do |count|
  Post.count.should == count.to_i
end

Before do
  Post.delete_all
end
