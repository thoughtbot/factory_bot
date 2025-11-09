---
type: note
created: 2025-11-08T18:41:41-06:00
updated: 2025-11-08T18:44:36-06:00
tags: []
aliases: []
---
# Factory Best Practices

## Use the Simplest Set of Attributes Necessary

It is recommended to define one factory for each class which provides the simplest set of attributes necessary to create an instance of that class.

## Define only Required Attributes

When creating ActiveRecord objects, only provide attributes that are required through validations and that do not have defaults.

## Expand Base Factories To Cover Common Scenarios

Additional factories can be created through inheritance to cover common scenarios for each class. Factories can also employ traits to group attributes that can be optionally included.
