---
type: note
created: 2025-11-07T18:57:56-06:00
updated: 2025-11-07T19:04:13-06:00
tags: []
aliases: []
---
# Factory Inheritance

FactoryBot supports factory inheritance through the creation of child factories. Factory inheritance enables you to create multiple factories for the same class without repeating common attributes. 

Child factories can be declared by either nesting factory declarations or explicitly assigning the parent.

## Nested Factories

A child factory can be declared by nesting the declaration of the child factory inside the parent factory:

```ruby
factory :post do
  title { "A title" }

  factory :approved_post do
    approved { true }
  end
end

approved_post = create(:approved_post)
approved_post.title    # => "A title"
approved_post.approved # => true
```

## Explicit Assignment of Parent Factory

You can also assign the parent explicitly:

```ruby
factory :post do
  title { "A title" }
end

factory :approved_post, parent: :post do
  approved { true }
end
```

## Best Practices

As mentioned above, it's good practice to define a basic factory for each class with only the attributes required to create it. Then, create more specific factories that inherit from this basic parent.
