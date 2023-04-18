# has_and_belongs_to_many associations

Generating data for a `has_and_belongs_to_many` relationship is very similar
to the above `has_many` relationship, with a small change: you need to pass an
array of objects to the model's pluralized attribute name rather than a single
object to the singular version of the attribute name.


```ruby
def profile_with_languages(languages_count: 2)
  FactoryBot.create(:profile) do |profile|
    FactoryBot.create_list(:language, languages_count, profiles: [profile])
  end
end
```

Or with the callback approach:

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

Or the inline association approach (note the use of the `instance` method here
to refer to the profile being built):

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
