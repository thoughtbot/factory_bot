---
type: note
created: 2025-11-07T20:59:14-06:00
updated: 2025-11-08T19:03:05-06:00
tags: []
aliases: []
---
# Building or Creating Multiple Objects

Sometimes, you'll want to construct multiple instances of a factory all at once. The methods below will build, stub, or create a specific quantity of objects and return them as an array. 

```ruby
built_users   = build_list(:user, 25)
stubbed_users = build_stubbed_list(:user, 25)
created_users = create_list(:user, 25)
```

you can also construct pairs of objects:

```ruby
pair_of_built_users   = build_pair(:user)
pair_of_stubbed_users = build_stubbed_pair(:user)
pair_of_created_users = create_pair(:user)
```

## Setting Attributes

To set the attributes for each produced object, you can pass in a hash as you normally would. However, the same value will be assigned to every object.

```ruby
twenty_year_olds = build_list(:user, 25, date_of_birth: 20.years.ago)
```

## Setting Different Attributes For Each Produced Object

In order to set different attributes for each object produced by the factory, the list methods may be passed a block, with the factory and the index as parameters:

```ruby
twenty_somethings = build_list(:user, 10) do |user, i|
  user.date_of_birth = (20 + i).years.ago
end
```

## Producing A List of Created Objects

When utilizing `create_list`, saved instances are passed into an included block. Thus if you modify the instance within the block, you must save it again:

```ruby
twenty_somethings = create_list(:user, 10) do |user, i|
  user.date_of_birth = (20 + i).years.ago
  user.save!
end
```

## Producing a List of Stubbed Objects

`build_stubbed_list` will give you fully stubbed out instances:

```ruby
stubbed_users = build_stubbed_list(:user, 25) # array of stubbed users
```

## Producing a Pair of Objects

There's also a set of `*_pair` methods for creating two records at a time:

```ruby
built_users   = build_pair(:user) # array of two built users
created_users = create_pair(:user) # array of two created users
```

## Producing a List of Attribute Hashes

If you need multiple attribute hashes, `attributes_for_list` will generate
them:

```ruby
users_attrs = attributes_for_list(:user, 25) # array of attribute hashes
```
