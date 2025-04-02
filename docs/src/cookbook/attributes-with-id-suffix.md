# Attributes with _id suffix

When using FactoryBot in a rails application, defining factory attributes ending with `_id` may cause an unexpected behaviour:

```ruby
# Migration:
  create_table :realtors, force: true do |t|
    t.boolean :duplicate, default: false, null: false
    t.string :duplicate_id
  end

# Factory
FactoryBot.define do
  factory :realtor do
    duplicate { false }
    duplicate_id { "This should exist" }
  end
end
```

```
realtor1 = create(:realtor, id: 6, duplicate: true, duplicate_id: 'dup1')
[1] pry> realtor1.duplicate_id
=> nil
```

A fix for this would be to make sure the special behavior related to `_id` is exclusive to `factory_bot_rails`, since `factory_bot` is framework-agnostic.

A workaround can be to use trasients to declare those attributes instead of a regular attribute declaration

```
    transient do
      duplicate { false }
      duplicate_id { "This should exist" }
    end

    initialize_with do
      new(attributes.merge(duplicate:, duplicate_id:))
    end
```

You can also override the list of aliases to include the attributes you want to exclude:

```
FactoryBot.aliases = [
  [/([^(?:duplicate)].+)_id/, '\1'],
  [/([^(?:duplicate)].*)/, '\1_id']
]
```

