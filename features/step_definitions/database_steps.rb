Then /^I should find the following for the last (.*):$/ do |model, table|
  model_class = model.camelize.constantize
  last_instance = model_class.last or raise "No #{model.pluralize} exist"
  table.hashes.first.each do |key, value|
    last_instance.attributes[key].to_s.should == value
  end
end

Then /^there should be (\d+) (.*)$/ do |count, model|
  model_class = model.singularize.camelize.constantize
  model_class.count.should == count.to_i
end

Then /^the post "([^"]*)" should (not )?have the following tags?:$/ do |post_title, negate, table|
  post = Post.find_by_title!(post_title)

  table.hashes.each do |row|
    tag = Tag.find_by_name(row[:name])

    if negate
      post.tags.should_not include(tag)
    else
      post.tags.should include(tag)
    end
  end
end

Transform /^table:(?:.*,)?tags(?:,.*)?$/ do |table|
  table.map_column!("tags") do |tags|
    tags.split(',').map {|tag| Tag.find_by_name! tag.strip }
  end
  table
end

Before do
  Post.delete_all
  Tag.delete_all
  User.delete_all
  Category.delete_all
  CategoryGroup.delete_all
end

