# Hash attributes

Because of the block syntax in Ruby, defining attributes as `Hash`es (for
serialized/JSON columns, for example) requires two sets of curly brackets:

```ruby
factory :program do
  configuration { { auto_resolve: false, auto_define: true } }
end
```
