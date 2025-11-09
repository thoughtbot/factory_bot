---
type: note
created: 2025-11-07T21:36:52-06:00
updated: 2025-11-07T21:37:39-06:00
tags: []
aliases: []
---
# Using Traits as Implicit Attributes

Traits can be used as implicit attributes:

```ruby
factory :week_long_published_story_with_title, parent: :story do
  published
  week_long_publishing
  title { "Publishing that was started at #{start_at}" }
end
```

> [!NOTE]
> Defining traits as implicit attributes will not work if you have a factory or sequence with the same name as the trait.
