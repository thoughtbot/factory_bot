# Method Name / Reserved Word Attributes

If your attributes conflict with existing methods or reserved words (all
methods in the
[DefinitionProxy](https://github.com/thoughtbot/factory_bot/blob/main/lib/factory_bot/definition_proxy.rb)
class) you can define them with `add_attribute`.

```ruby
factory :dna do
  add_attribute(:sequence) { 'GATTACA' }
end

factory :payment do
  add_attribute(:method) { 'paypal' }
end
```
