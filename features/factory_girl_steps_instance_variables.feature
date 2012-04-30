Feature: Step definitions generated by factories create instance variables
  
  Background:
    Given I have set FactoryGirl::StepDefinitions.create_instance_variables to true

  # Given /^an? #{human_name} exists with an? #{human_column_name} of "([^"]*)"$/i do |value|
  Scenario: the factory girl step "/^an? \#{human_name} exists with an? \#{human_column_name} of \"([^\"]*)\"$/i" creates an instance variable containing a single object with the correct attribute value
    Given a post exists with a title of "a fun title"
    Then an instance variable named "post" should be set with the following attributes:
      | title       |
      | a fun title |
    And the instance variable named "post" should not be an array
  
  # Given /^(\d+) #{human_name.pluralize} exist with an? #{human_column_name} of "([^"]*)"$/i do |count, value|
  Scenario: the factory girl step "/^(\d+) \#{human_name.pluralize} exist with an? #{human_column_name} of \"([^\"]*)\"$/i" creates an instance variable containing an array of n objects with the correct attribute values
    Given 2 users exist with a name of "Uncle Bob"
    Then an instance variable named "users" should be set with the following attributes:
      | name      |
      | Uncle Bob |    
      | Uncle Bob |    
    And the instance variable named "users" should be an array
  
  # Given /^(\d+) #{human_name.pluralize} exist$/i do |count|
  Scenario: the factory girl step "/^(\d+) \#{human_name.pluralize} exist$/i" creates an instance variable containing an array of n objects
    Given 8 categories exist
    Then an instance variable named "categories" should be set with 8 elements
    And the instance variable named "categories" should be an array
  
  # Given /^an? #{human_name} exists$/i do
  Scenario: the factory girl step "/^an? \#{human_name} exists$/i" creates an instance variable should be created containing a single object
    Given a post exists
    Then an instance variable named "post" should be set with 1 element
    And the instance variable named "post" should not be an array
    
  # Given /^the following (#{human_name}|#{human_name.pluralize}) exists?:?$/i do |instance_name, table|
  Scenario: the factory girl step "/^the following (\#{human_name}|\#{human_name.pluralize}) exists?:?$/i" creates an instance variable containing an array of the same number of objects as the table has rows, each with the correct attribute values
    Given the following post exists:
      | Title | Body   |
      | one   | first  |
    And the following categories exist:
      | Name    |
      | science |
      | fiction |
    Then an instance variable named "post" should be set with the following attributes:
      | Title | Body   |
      | one   | first  |
    And the instance variable named "post" should be an array
    Then an instance variable named "categories" should be set with the following attributes:
      | Name    |
      | science |
      | fiction |
    And the instance variable named "categories" should be an array
  
  Scenario: the factory girl step "/^the following (\#{human_name}|\#{human_name.pluralize}) exists?:?$/i" creates an instance variable using the same pluralization as the feature step specifies regardless of how many factoried objects are created
    Given the following posts exist:
      | Title                |
      | how to draw a circle |
    And the following post exists:
      | Title        |
      | scope ambiguity and referential opacity on the influence of Roman currency in Ohio |
      | the crow                                                                           |
      | Fooby Fooby Foo                                                                    |
    Then an instance variable named "posts" should be set with the following attributes:
      | Title                |
      | how to draw a circle |
    And an instance variable named "post" should be set with the following attributes:
      | Title        |
      | scope ambiguity and referential opacity on the influence of Roman currency in Ohio |
      | the crow                                                                           |
      | Fooby Fooby Foo                                                                    |
  
  Scenario: factory girl instance variables can be created from multi-word factories
    Given an admin user exists with a name of "Super User"
    Then an instance variable named "admin_user" should be set with the following attributes:
      | name       |
      | Super User |
    And the instance variable named "admin_user" should not be an array

  Scenario: factory girl instance variables can be created from aliased factories
    Given a person exists with a name of "Peter"
    Then an instance variable named "person" should be set with the following attributes:
      | name  |
      | Peter |
    And the instance variable named "person" should not be an array

  Scenario: factory girl instance variables can be created from pluralized aliased factories
    Given 3 people exist with a name of "Peter"
    Then an instance variable named "people" should be set with the following attributes:
      | name  |
      | Peter |
      | Peter |
      | Peter |
    And the instance variable named "people" should be an array

  Scenario: a feature that generates multiple factoried objects of the same name and pluralization will create an instance variable of the same name and pluralization based only on the last instance of factoried objects
    Given an admin user exists with a name of "Super User"
    And an admin user exists with a name of "Scarlet Pimpernel"
    And the following categories exist:
      | Name     |
      | thriller |
      | action   |
    And the following categories exist:
      | Name               |
      | historical fiction |
      | murder mystery     |
      | british recipes    |
    Then an instance variable named "admin_user" should be set with the following attributes:
      | name              |
      | Scarlet Pimpernel |
    And an instance variable named "categories" should be set with the following attributes:
      | Name               |
      | historical fiction |
      | murder mystery     |
      | british recipes    |
  
  Scenario: factory girl step definitions should not create instance variables when the FactoryGirl.create_instance_variables attribute is false
    Given I have set FactoryGirl::StepDefinitions.create_instance_variables to false
    And a post exists with a title of "a fun title"
    And 2 users exist with a name of "Uncle Bob"
    And 8 categories exist
    And a category group exists
    And the following admin users exist:
      | Name  |
      | Carl  |
      | Kenny |
    Then an instance variable named "post" should not be set
    And an instance variable named "users" should not be set
    And an instance variable named "categories" should not be set
    And an instance variable named "category_group" should not be set
    And an instance variable named "admin_users" should not be set
