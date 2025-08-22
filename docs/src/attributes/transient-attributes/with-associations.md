# With associations

Transient [associations](../associations/summary.md) are not supported in
factory\_bot. Associations within the transient block will be treated as
regular, non-transient associations.

If needed, you can generally work around this by building a factory within a
transient attribute:

```ruby
factory :post

factory :user do
  transient do
    post { build(:post) }
  end
end
```
