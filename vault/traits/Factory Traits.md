---
type: note
created: 2025-11-07T21:16:16-06:00
updated: 2025-11-08T20:22:24-06:00
tags: []
aliases: []
---
# Factory Traits

**Factory Traits** allow you to group attributes together and apply them to a factory.

```ruby
FactoryBot.define do
  factory :user, aliases: [:author]
  
  factory :story do
    title { "My awesome story" }
    author
  
    trait :published do
      published { true }
    end
  
    trait :unpublished do
      published { false }
    end
  
    trait :week_long_publishing do
      start_at { 1.week.ago }
      end_at { Time.now }
    end
  
    trait :month_long_publishing do
      start_at { 1.month.ago }
      end_at { Time.now }
    end
  
    factory :week_long_published_story, 
      traits: [:published, :week_long_publishing]
    factory :month_long_published_story,
      traits: [:published, :month_long_publishing]
    factory :week_long_unpublished_story,  
      traits: [:unpublished, :week_long_publishing]
    factory :month_long_unpublished_story, 
      traits: [:unpublished, :month_long_publishing]
  end
end
```
