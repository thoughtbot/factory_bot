# Building or Creating Multiple Records

Sometimes, you'll want to create or build multiple instances of a factory at
once.

```ruby
built_users   = build_list(:user, 25)
created_users = create_list(:user, 25)
```

These methods will build or create a specific amount of factories and return
them as an array. To set the attributes for each of the factories, you can pass
in a hash as you normally would.

```ruby
twenty_year_olds = build_list(:user, 25, date_of_birth: 20.years.ago)
```

In order to set different attributes for each factory, these methods may be
passed a block, with the factory and the index as parameters:

```ruby
twenty_somethings = build_list(:user, 10) do |user, i|
  user.date_of_birth = (20 + i).years.ago
end
```

`create_list` passes saved instances into the block. If you modify the
instance, you must save it again:

```ruby
twenty_somethings = create_list(:user, 10) do |user, i|
  user.date_of_birth = (20 + i).years.ago
  user.save!
end
```

`build_stubbed_list` will give you fully stubbed out instances:

```ruby
stubbed_users = build_stubbed_list(:user, 25) # array of stubbed users
```

There's also a set of `*_pair` methods for creating two records at a time:

```ruby
built_users   = build_pair(:user) # array of two built users
created_users = create_pair(:user) # array of two created users
```

If you need multiple attribute hashes, `attributes_for_list` will generate
them:

```ruby
users_attrs = attributes_for_list(:user, 25) # array of attribute hashes
```

