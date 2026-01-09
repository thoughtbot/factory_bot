---
type: note
created: 2025-11-07T18:57:56-06:00
updated: 2026-01-09T15:00:01-06:00
tags: []
aliases: []
up: "[[Factories]]"
---
# Factory Inheritance

FactoryBot supports [[Factories|Factory]] *inheritance* through the creation of [[Child Factories]]. 

Factory inheritance enables you to create multiple factories for the same class without repeating common attributes. The child factories can be declared by either nesting factory declarations or explicitly assigning the parent.

As mentioned above, it's good practice to define a basic factory for each class with only the attributes required to create it. Then, create more specific factories that inherit from this basic parent.

To learn about the syntax, see [[Child Factories]]