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
    after(:build) { puts "User after(:build)"
    
    trait :trait_a do
      after(:build) { puts "Trait-A after(:build)" 
    end
    
    trait :trait_b do 
      after(:build) { puts "Trait-B after(:build)" }
    end
  end
end

build(:user, :trait_b, :trait_a) 

# Result:
#
# 1. "Global before(:all)"
# 2. "User before(:all)"
# 3. "User after(:build)"
# 4. "Trait-B after(:build)"
# 5. "Trait-A after(:build)"
# 6. "Global after(:all)"
# 7. "User after(:all)"

```


## An inherited factory example:

```ruby
FactoryBot.define do
  before(:all) { puts "Global before(:all)" }
  after(:build) { puts "Global after(:build)" }
  after(:all) { puts "Global after(:all)" }

  factory :parent do
    before(:all) { puts "Parent before(:all)" }
    after(:all) { puts "Parent after(:all)" }
    after(:build) { puts "Parent after(:build)" }
    
    trait :trait_a do 
      after(:build) { puts "Trait-A after(:build)" }
    end

    factory :child do
      before(:all) { puts "Child before(:all)" }
      after(:build) { puts "Child after(:build)" }
      after(:all) { puts "Child after(:all)" }

      trait :trait_b do
        after(:build) { puts "Trait-B after(:build)" }
        after(:all) { puts "Trait-B after(:all)" }
      end

      trait :trait_c do
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
# 5. "Global after(:build)"
# 6. "Parent after(:build)"
# 7. "Child after(:build)"
# 8. "Trait-C after(:build)"
# 9. "Trait-A after(:build)"
# 10. "Trait-B after(:build)"
# 11. "Global after(:all)"
# 12. "Parent after(:all)"
# 13. "Child after(:all)"
# 14. "Trait-B after(:all)"

```
