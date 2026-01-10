---
type: note
created: 2025-11-07T21:10:45-06:00
updated: 2026-01-09T17:56:43-06:00
tags: []
aliases:
up: "[[Traits]]"
---
# Overview of Traits

## Introduction

Traits allow you to group attributes together and apply them to a factory

- [[Factory Traits]] define a factory-scoped group of attributes
- [[Global Traits]] define a globally-scoped group of attributes
- [[Enum Traits]] define a group of traits for every possible value of an enum

## Syntax

Within a `factory` definition block, the `trait` method can be used to define named permutations of the factory. The trait method takes a name (Symbol) and a block. Treat the block like you would a [[Factories|Factory]] definition block.

```ruby
factory :user do
  name { "Friendly User" }
  login { name }

  trait :active do
    status { :active }
  end
end
```

## Examples

- [[Using Traits When Constructing Objects]]
- [[Using Traits When Constructing Lists of Objects]]