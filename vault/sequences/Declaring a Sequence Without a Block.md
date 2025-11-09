---
type: note
created: 2025-11-07T15:19:50-06:00
updated: 2025-11-07T15:22:09-06:00
tags: []
aliases: []
---
# Declaring a Sequence Without a Block

Without a block, the value will increment itself, starting at its initial value.

## Example: Numerical Sequence

```ruby
factory :post do
  sequence(:position)
end
```

## Example: Enumerable Instance

Note that the value for the sequence could be any Enumerable instance, as long
as it responds to `#next`:

```ruby
factory :task do
  sequence :priority, %i[low medium high urgent].cycle
end
```
