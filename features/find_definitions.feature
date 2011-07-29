Feature: Factory girl can find factory definitions correctly
  Scenario: Find definitions with a path
    Given a file named "awesome_factories.rb" with:
    """
    FactoryGirl.define do
      factory :awesome_category, :class => Category do
        name "awesome!!!"
      end
    end
    """
    When "awesome_factories.rb" is added to Factory Girl's file definitions path
    And I create a "awesome_category" instance from Factory Girl
    Then I should find the following for the last category:
      | name       |
      | awesome!!! |

  Scenario: Find definitions with an absolute path
    Given a file named "awesome_factories.rb" with:
    """
    FactoryGirl.define do
      factory :another_awesome_category, :class => Category do
        name "awesome!!!"
      end
    end
    """
    When "awesome_factories.rb" is added to Factory Girl's file definitions path as an absolute path
    And I create a "another_awesome_category" instance from Factory Girl
    Then I should find the following for the last category:
      | name       |
      | awesome!!! |

  Scenario: Find definitions with a folder
    Given a file named "nested/great_factories.rb" with:
    """
    FactoryGirl.define do
      factory :great_category, :class => Category do
        name "great!!!"
      end
    end
    """
    When "nested" is added to Factory Girl's file definitions path
    And I create a "great_category" instance from Factory Girl
    Then I should find the following for the last category:
      | name     |
      | great!!! |

  Scenario: Find definitions after clearing loaded factories
    Given a file named "nested/swell_factories.rb" with:
    """
    FactoryGirl.define do
      factory :swell_category, :class => Category do
        name "swell!!!"
      end
    end
    """
    When "nested" is added to Factory Girl's file definitions path
    And I clear out the factories
    And I find definitions
    And I create a "swell_category" instance from Factory Girl
    Then I should find the following for the last category:
      | name     |
      | swell!!! |
