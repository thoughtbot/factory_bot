---
type: note
created: 2025-08-29T16:12:00-05:00
updated: 2026-03-06T14:58:03-06:00
tags:
  - strategies
aliases:
  - Strategy
  - Strategies
  - Construction Strategy
  - Construction Strategies
up: "[[§ Strategies]]"
---
# Strategies

A Factory **Strategy** encapsulates an algorithm for varying how the [[§ Factories|Factory]] constructs example objects. FactoryBot includes a set of four core construction strategies: `build`, `build_stubbed`, `create`, and `attributes_for`.

## Built-In Strategies

The built-in strategies are as follows:

- [[build Strategy|build]] — constructs an instance of the object class
- [[create Strategy|create]] — constructs an instance of the object class and invokes `#save`
- [[Stub Strategy|build_stubbed]] — constructs an stubbed instance of the object class
- [[AttributesFor Strategy|attributes_for]] — constructs a Hash containing the factory attributes
- [[null Strategy|null]] — returns `nil`

## Syntax

### Base Methods

The base non-list methods (`.build`, `.build_pair`, `.create`, etc.) take one mandatory argument: the `name` of the factory. They can then optionally take names of traits, and then a hash of attributes to override. Finally, they can take a block. This block takes the produced object as an argument, and returns an updated object.

### List Methods

The list methods (`.build_list`, `.create_list`, etc.) have two required arguments: the name of the factory, and the number of instances to build. They then can optionally take traits and overrides. Finally, they can take a block. This block takes the produced object and the zero-based index as arguments, and returns an updated object.
