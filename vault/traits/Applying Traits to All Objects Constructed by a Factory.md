---
type: note
created: 2026-02-28T10:01:58-06:00
updated: 2026-02-28T10:26:56-06:00
tags: []
aliases: []
---
# Applying Traits to All Objects Constructed by a Factory

[[Traits]] can be applied to all object constructed by a factory by passing in a `:traits` option during declaration:

```ruby
factory :user, traits: [:inactive] do
  admin { false }
  
  trait :active do
    status { :active }
  end

  trait :inactive do
    status { :inactive }
  end

  trait :admin do
    admin { true }
  end

  factory :active_admin, traits: [:active, :admin]
end
```

In the example above, the `:user` factory will default to having the `:inactive` trait applied to all constructed objects.

Note that the `:active_admin` child factory will still apply the `:inactive` trait,  as well as also applying the `:active`, and `:admin` traits. The order of precedence, however, will take effect and only the block passed to `status` from the `:active` trait will be invoked. Any callbacks from the `:inactive` trait will still be called. Other attributes that have not been overridden will also still be applied.
