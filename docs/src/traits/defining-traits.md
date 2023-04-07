# Defining traits

Traits allow you to group attributes together and then apply them
to any factory.

```ruby
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

  factory :week_long_published_story,    traits: [:published, :week_long_publishing]
  factory :month_long_published_story,   traits: [:published, :month_long_publishing]
  factory :week_long_unpublished_story,  traits: [:unpublished, :week_long_publishing]
  factory :month_long_unpublished_story, traits: [:unpublished, :month_long_publishing]
end
```
