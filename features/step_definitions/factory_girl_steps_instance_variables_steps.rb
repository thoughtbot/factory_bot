Then /^an instance variable named "([^"]+)" should be set$/ do |instance_name|
  @__memoized_factory_girl_instance_variable = instance_variable_get("@#{instance_name}")
  @__memoized_factory_girl_instance_variable.should_not be_nil
end

Then /^an instance variable named "([^"]+)" should be set with ([\d]+) (?:element(?:s)?|row(?:s)?)$/ do |instance_name, instance_size|
  step %Q(an instance variable named "#{instance_name}" should be set)  
  @__memoized_factory_girl_instance_variable = Array(@__memoized_factory_girl_instance_variable)
  @__memoized_factory_girl_instance_variable.size.should == instance_size.to_i
end

Then /^an instance variable named "([^"]+)" should be set with the following attributes(?::)?$/ do |instance_name, table|
  table.map_headers! { |header| header.downcase.to_sym }
  step %Q(an instance variable named "#{instance_name}" should be set with #{table.hashes.size} rows)
  table.hashes.each_with_index do |row, index|
    table.headers.each do |key|
      @__memoized_factory_girl_instance_variable[index].send(key).to_s.should eq(row[key])
    end
  end
end

Then /^the instance variable named "([^"]*)" should( not)? be an array$/ do |instance_name, negation|
  assertion = negation ? :should_not : :should
  instance_variable_get("@#{instance_name}").class.to_s.send(assertion, eq("Array"))
end

Given /^I have set FactoryGirl::StepDefinitions.create_instance_variables to (false|true)$/ do |state|
  FactoryGirl::StepDefinitions.create_instance_variables = (state == "true") ? true : false
end

Then /^an instance variable named "([^"]*)" should not be set$/ do |instance_name|
  instance_variable_get("@#{instance_name}").should be_nil
end
