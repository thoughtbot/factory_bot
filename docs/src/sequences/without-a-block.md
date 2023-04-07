# Without a block

Without a block, the value will increment itself, starting at its initial value:

```ruby
factory :post do
  sequence(:position)
end
```

Note that the value for the sequence could be any Enumerable instance, as long
as it responds to `#next`:

```ruby
factory :task do
  sequence :priority, %i[low medium high urgent].cycle
end
```
