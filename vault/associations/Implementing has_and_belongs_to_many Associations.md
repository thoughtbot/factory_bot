---
type: note
created: 2025-11-07T22:40:17-06:00
updated: 2025-11-07T22:42:09-06:00
tags: []
aliases: []
---
# Implementing has_and_belongs_to_many Associations

Generating data for a `has_and_belongs_to_many` relationship is very similar to the approach discussed for [[Implementing has_many Associations]], with a small change: you need to pass an array of objects to the model's pluralized attribute name rather than a single object to the singular version of the attribute name.

## Helper Method Approach

```ruby
def profile_with_languages(languages_count: 2)
  FactoryBot.create(:profile) do |profile|
    FactoryBot.create_list(:language, languages_count, profiles: [profile])
  end
end
```

## Callback Approach

```ruby
factory :profile_with_languages do
  transient do
    languages_count { 2 }
  end

  after(:create) do |profile, context|
    create_list(:language, context.languages_count, profiles: [profile])
    profile.reload
  end
end
```

## Inline Approach

Or the inline association approach (note the use of the `instance` method here to refer to the profile being built):

```ruby
factory :profile_with_languages do
  transient do
    languages_count { 2 }
  end

  languages do
    Array.new(languages_count) do
      association(:language, profiles: [instance])
    end
  end
end
```
