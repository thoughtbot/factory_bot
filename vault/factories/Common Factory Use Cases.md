---
type: note
created: 2026-03-06T14:43:58-06:00
updated: 2026-03-06T15:00:58-06:00
tags: []
aliases: []
---
# Common Factory Use Cases

The most common uses of a [[Factories|Factory]] include building unsaved objects; creating saved objects; stubbing objects; or constructing a hash of attributes.

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

## Returning an Unsaved User

Use the [[build Strategy|build]] strategy to return a `User` instance that is not saved:

```ruby
user = build(:user)
```

## Returning a Saved User

Use a [[create Strategy|create]] strategy to return a `User` instance that is saved:

```ruby
user = create(:user)
```

## Retrieving a Hash of Attributes

The [[AttributesFor Strategy|attributes_for]] strategy can be used to returns a `Hash` of attributes. This hash can  then be used to build a `User` instance or be transformed into JSON.

```ruby
attrs = attributes_for(:user)
```

## Assigning Attributes With Pattern Matching

The [[AttributesFor Strategy|attributes_for]] strategy also integrates well with ruby 3.0's support for pattern matching assignment:

```ruby
attributes_for(:user) => {email:, name:, **attrs}
```

## Returning a Stubbed Version of User

The [[Stub Strategy|build_stubbed]] strategy returns an object with all defined attributes stubbed out:

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
