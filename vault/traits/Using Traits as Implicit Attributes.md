---
type: note
created: 2025-11-07T21:36:52-06:00
updated: 2026-02-28T09:28:53-06:00
tags: []
aliases:
  - Activating Traits with Implicit Syntax
up: "[[§ Traits]]"
---
# Using Traits as Implicit Attributes

Traits can be **implicitly activated** by use of the [[Missing Method Shorthand Syntax]]. In this way traits can be used as implicit attributes:

```ruby
FactoryBot.define
  factory :story do
    trait :published do
      published { true }
    end
    
    trait :week_long_publishing do
      start_at { 1.week.ago }
      end_at { Time.now }
    end
  end
  
  factory :week_long_published_story_with_title, parent: :story do
    published
    week_long_publishing
    title { "Publishing that was started at #{start_at}" }
  end
end
```


> [!IMPORTANT]
> Defining traits as implicit attributes will not work if you have a factory or sequence with the same name as the trait.








