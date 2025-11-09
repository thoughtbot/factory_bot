---
type: note
created: 2025-11-07T13:58:47-06:00
updated: 2025-11-07T14:03:36-06:00
tags: []
aliases: []
---
# Handling Conflicts Between Attributes And Reserved Words Or Existing Methods

If the name of an attribute conflicts with existing methods[^1] or reserved words[^2] you can define the attribute with `add_attribute`.

```ruby
factory :dna do
  add_attribute(:sequence) { 'GATTACA' }
end

factory :payment do
  add_attribute(:method) { 'paypal' }
end
```

[^1]: Existing methods are all the methods provided by the [DefinitionProxy](https://github.com/thoughtbot/factory_bot/blob/main/lib/factory_bot/definition_proxy.rb) class
[^2]: Reserved words are all the Ruby keywords. A list can be found here: https://docs.ruby-lang.org/en/3.4/syntax/keywords_rdoc.html