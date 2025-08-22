# Transient Attributes

Transient attributes are attributes only available within the factory
definition, and not set on the object being built. This allows for more complex
logic inside factories.

These are defined within a `transient` block:

```ruby
factory :user do
  name { "Zero Cool" }
  birth_date { age&.years.ago }

  transient do
    age { 11 } # only used to set `birth_date` above
  end
end
```
