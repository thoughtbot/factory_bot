---
type: note
created: 2025-08-29T15:45:11-05:00
updated: 2026-01-09T16:27:43-06:00
tags:
  - strategies
aliases:
  - build_stubbed
  - build_stubbed Strategy
  - The build_stubbed Strategy
up: "[[§ Strategies]]"
---
# Stub Strategy

The **Stub Strategy** constructs a fake ActiveRecord object. 

## Syntax Methods

- `FactoryBot.build_stubbed`
- `FactoryBot.build_stubbed_pair`
- `FactoryBot.build_stubbed_list`

The behavior of the Stub strategy methods are defined similarly to those of the [[Build Strategy]] (`.build`, `.build_pair`, and `.build_list`).

## Stubbing Strategy

The strategy employs `initialize_with` to construct the object, but then stubs methods and data as appropriate:

| Property       | Value                                        |
| -------------- | -------------------------------------------- |
| `id`           | identifiers are set sequentially<sup>†</sup> |
| `created_at`   | set to the current time<sup>†</sup>          |
| `updated_at`   | set to the current time<sup>†</sup>          |
| `#persisted?`  | set to `true`                                |
| `#new_record?` | set to `false`                               |
| `#destroyed?`  | set to `false`                               |
| `#connection`  | raises a `RuntimeError`                      |
| `#delete`      | raises a `RuntimeError`                      |
| `#save`        | raises a `RuntimeError`                      |
| `#update`      | raises a `RuntimeError`                      |
† *(unless overridden by attributes)*

- all [ActiveModel::Dirty](https://api.rubyonrails.org/classes/ActiveModel/Dirty.html) change tracking is cleared
- persistence methods overridden to raise a `RuntimeError` 
- after the strategy sets up the object, it invokes the `after_stub` hook.

## Incompatibility With `Marshal.dump`

objects created with `build_stubbed` cannot be serialized with `Marshal.dump`, since factory\_bot defines singleton methods on these objects.
