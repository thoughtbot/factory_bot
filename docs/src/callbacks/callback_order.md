# Callback Order

When a callback event like `after_build` or `before_all` is triggered, all callbacks for that event are excuted in the following order:

1. Global callbacks.
2. Inherited callbacks.
3. Factory callbacks.
4. Trait callbacks (in the order requested).

## A simple factory example:

```ruby
FactoryBot.define do
  before(:all) { puts "Global before(:all)" }
  after(:all) { puts "Global after(:all)" }

  factory :user do
    before(:all) { puts "User before(:all)" }
    after(:all) { puts "User after(:all)" }
    before(:build) { puts "User before(:build)" }
    after(:build) { puts "User after(:build)" }

    trait :trait_a do
      before(:build) { puts "Trait-A before(:build)" }
      after(:build) { puts "Trait-A after(:build)" }
    end

    trait :trait_b do
      before(:build) { puts "Trait-B before(:build)" }
      after(:build) { puts "Trait-B after(:build)" }
    end
  end
end

build(:user, :trait_b, :trait_a)

# Result:
#
# 1. "Global before(:all)"
# 2. "User before(:all)"
# 3. "User before(:build)
# 4. "Trait-B before(:build)"
# 5. "Trait-A before(:build)"
# 6. "User after(:build)"
# 7. "Trait-B after(:build)"
# 8. "Trait-A after(:build)"
# 9. "Global after(:all)"
# 10. "User after(:all)"

```


## An inherited factory example:

```ruby
FactoryBot.define do
  before(:all) { puts "Global before(:all)" }
  before(:build) { puts "Global before(:build)" }
  after(:build) { puts "Global after(:build)" }
  after(:all) { puts "Global after(:all)" }

  factory :parent do
    before(:all) { puts "Parent before(:all)" }
    before(:build) { puts "Parent before(:build)" }
    after(:all) { puts "Parent after(:all)" }
    after(:build) { puts "Parent after(:build)" }

    trait :trait_a do
      before(:build) { puts "Trait-A before(:build)" }
      after(:build) { puts "Trait-A after(:build)" }
    end

    factory :child do
      before(:all) { puts "Child before(:all)" }
      before(:build) { puts "Child before(:build)" }
      after(:build) { puts "Child after(:build)" }
      after(:all) { puts "Child after(:all)" }

      trait :trait_b do
        before(:build) { puts "Trait-B before(:build)" }
        after(:build) { puts "Trait-B after(:build)" }
        after(:all) { puts "Trait-B after(:all)" }
      end

      trait :trait_c do
        before(:build) { puts "Trait-C before(:build)" }
        after(:build) { puts "Trait-C after(:build)" }
        before(:all) { puts "Trait-C before(:all)" }
      end
    end
  end
end

build(:child, :trait_c, :trait_a, :trait_b)

# Result:
#
# 1. "Global before(:all)"
# 2. "Parent before(:all)"
# 3. "Child before(:all)"
# 4. "Trait-C before(:all)"
# 5. "Global before(:build)"
# 6. "Parent before(:build)"
# 7. "Child before(:build)"
# 8. "Trait-C before(:build)"
# 9. "Trait-A before(:build)"
# 10. "Trait-B before(:build)"
# 11. "Global after(:build)"
# 12. "Parent after(:build)"
# 13. "Child after(:build)"
# 14. "Trait-C after(:build)"
# 15. "Trait-A after(:build)"
# 16. "Trait-B after(:build)"
# 17. "Global after(:all)"
# 18. "Parent after(:all)"
# 19. "Child after(:all)"
# 20. "Trait-B after(:all)"
```
