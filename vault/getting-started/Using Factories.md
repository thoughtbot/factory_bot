---
type: note
created: 2025-08-29T15:33:57-05:00
updated: 2025-11-08T18:57:33-06:00
tags: []
aliases:
---
# Using Factories

## Build Strategies

FactoryBot supports several different build strategies: 

- [[build Strategy|build]]
- [[create Strategy]]
- [[build_stubbed Strategy]]
- [[attributes_for Strategy]]
- [[null Strategy]]

## Examples

Given the following factory declaration, the sections below provide demonstration of it's usage.

```ruby
FactoryBot.define do
  factory :user do
    first_name { "John" }
    last_name  { "Doe" }
    admin { false }
  end
end
```

## Return an Unsaved User

Use the [[build Strategy|build]] strategy to return a `User` instance that is not saved:

```ruby
user = build(:user)
```

## Return a Saved User

Use a [[create Strategy|create]] strategy to return a `User` instance that is saved:

```ruby
user = create(:user)
```

## Retrieve a Hash of Attributes

The [[attributes_for Strategy|attributes_for]] strategy can be used to returns a `Hash` of attributes. This hash can  then be used to build a `User` instance or be transformed into JSON.

```ruby
attrs = attributes_for(:user)
```

## Pattern Matching Assignment

The [[attributes_for Strategy|attributes_for]] strategy also integrates well with ruby 3.0's support for pattern matching assignment:

```ruby
attributes_for(:user) => {email:, name:, **attrs}
```

## Return a Stubbed Version of User

The [[build_stubbed Strategy|build_stubbed]] strategy returns an object with all defined attributes stubbed out:

```ruby
stub = build_stubbed(:user)
```

## Passing a Block to A Strategy

Passing a block to any of the strategy syntax methods listed above will yield the object or hash being constructed by the factory:

```ruby
create(:user) do |user|
  user.posts.create(attributes_for(:post))
end
```

## Next

[[Build Strategy]]

Refer to [[§ strategies|Strategies]] for more information on FactoryBot's construction strategies

Next we'll explore [[Modifying Existing Factories]]
