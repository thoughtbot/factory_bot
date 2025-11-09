---
type: note
created: 2025-11-08T21:36:03-06:00
updated: 2025-11-08T22:03:34-06:00
tags: []
aliases: []
---
# Attribute Aliases

FactoryBot's **aliases** are an overloaded concept.

- There are [[Factory Name Aliases]] (which this section does not cover) which declare alternative names for [[§ factories|Factories]]
- There are **Attribute Name Aliases** which allow you to declare alternative names for [[§ attributes|Attributes]]
- And finally there are "aliases" which are used by [[§ associations|Associations]]

## Attribute Aliases

An attribute alias is an alternative name or reference to the same attribute.

Attribute alias patterns can only be declared globally. As a result they apply for all factories.

## Association Aliases

**Association Aliases** are a misnomer and don't (exactly) exist. Rather, [[§ associations|Associations]] co-opt the **attribute alias** mechanism as an internal mapping between two related fields on an object

The first field is the attribute which maps to the persisted table row containing the foreign key to an associated record. The second field is virtual model attribute which, when invoked, returns an `ActiveRecord::Relation` (If you're using Rails' ActiveRecord).

## The `FactoryBot.aliases` List

`FactoryBot.aliases` is an Array of tuples (an ordered list of items). The tuples contain two regular expressions. 

- The first regex matches against an attribute name passed into the `aliases_for` method. 
- The second regex is a replacement used to generate the other alias in the reflection

Default list of alias patterns:

```ruby
FactoryBot.aliases = [
  [/(.+)_id/, '\1'],
  [/(.*)/, '\1_id']
]
```

It's important to note that both reflections of an alias should be included in the list. The default patterns, for example, will identify `:user` as an alias of `:user_id` AND it will also identify `:user_id` as an alias of `:user`.

## `FactoryBot.aliases_for`

Given an [[§ attributes|Attribute]] name (as a Symbol), the `aliases_for` method generates a list of names that includes all possible aliases and the original name.

For example, if you pass in `:user`:

```ruby
FactoryBot.aliases_for(:user)
# => [:user_id, :user]
```

On the other hand, when you pass in `:user_id`:

```ruby
FactoryBot.aliases_for(:user_id)
# => [:user, :user_id_id, :user_id]
```

You'll notice that this has the odd effect of including `:user_id_id` as a potential name of an alias. Fortunately, this has no ill effect on the FactoryBot internals which handle attributes and associations.
