# As implicit attributes

Traits can be used as implicit attributes:

```ruby
factory :week_long_published_story_with_title, parent: :story do
  published
  week_long_publishing
  title { "Publishing that was started at #{start_at}" }
end
```

Note that defining traits as implicit attributes will not work if you have a
factory or sequence with the same name as the trait.
