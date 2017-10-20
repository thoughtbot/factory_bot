Feature: FactoryBot can find factory definitions correctly
  Scenario: Find definitions with a path
    Given a file named "awesome_factories.rb" with:
    """
    FactoryBot.define do
      factory :awesome_category, :class => Category do
        name "awesome!!!"
      end
    end
    """
    When "awesome_factories.rb" is added to FactoryBot's file definitions path
    And I create a "awesome_category" instance from FactoryBot
    Then I should find the following for the last category:
      | name       |
      | awesome!!! |

  Scenario: Find definitions with an absolute path
    Given a file named "awesome_factories.rb" with:
    """
    FactoryBot.define do
      factory :another_awesome_category, :class => Category do
        name "awesome!!!"
      end
    end
    """
    When "awesome_factories.rb" is added to FactoryBot's file definitions path as an absolute path
    And I create a "another_awesome_category" instance from FactoryBot
    Then I should find the following for the last category:
      | name       |
      | awesome!!! |

  Scenario: Find definitions with a folder
    Given a file named "nested/great_factories.rb" with:
    """
    FactoryBot.define do
      factory :great_category, :class => Category do
        name "great!!!"
      end
    end
    """
    When "nested" is added to FactoryBot's file definitions path
    And I create a "great_category" instance from FactoryBot
    Then I should find the following for the last category:
      | name     |
      | great!!! |

  Scenario: Reload FactoryBot
    Given a file named "nested/reload_factories.rb" with:
    """
    FactoryBot.define do
      sequence(:great)
      trait :admin do
        admin true
      end

      factory :handy_category, :class => Category do
        name "handy"
      end
    end
    """
    When "nested" is added to FactoryBot's file definitions path
    And I append to "nested/reload_factories.rb" with:
    """

    FactoryBot.modify do
      factory :handy_category do
        name "HANDY!!!"
      end
    end
    """
    And I reload factories
    And I create a "handy_category" instance from FactoryBot
    Then I should find the following for the last category:
      | name     |
      | HANDY!!! |
