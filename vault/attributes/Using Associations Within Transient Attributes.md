---
type: note
created: 2025-11-07T18:18:35-06:00
updated: 2025-11-07T18:25:52-06:00
tags: []
aliases: []
---
# Using Associations Within Transient Attributes


> [!WARNING] Important
> Transient [associations](../associations/summary.md) are **not** directly supported in factory\_bot. 
> 
> Attempts to declare Associations within the transient block will be treated as regular, non-transient associations.

## Workaround

Similar functionality can be achieved by running a factory within a transient attribute. Use the `build`, `build_stubbed`, or `create` syntax to construct the desired object.

```ruby
factory :post

factory :user do
  transient do
    post { build(:post) }
  end
end
```

In the example above, the transient attribute `post` contains a reference to built instance of the `Post` class. The `post` will not be assigned to an object built by the `:user` factory.

One limitation to this approach is that strategy used to construct `post` will not be affected by the strategy employed when running the `:user` factory.
