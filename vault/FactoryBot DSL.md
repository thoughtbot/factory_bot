---
type: note
created: 2026-02-27T14:38:24-06:00
updated: 2026-03-06T16:30:24-06:00
tags:
  - stub
aliases: []
---
# FactoryBot DSL

The FactoryBot DSL provides two levels of methods. Top-level methods are used to define the factories and other globally scoped features. The secondary level of methods are available inside blocks passed into the declaration of a Factory or Trait and are scoped within that context.

## Top-Level DSL Methods

The top-level methods are available inside a `FactoryBot.define`  or `FactoryBot.update` block.

### Syntax Available Inside `FactoryBot.define`

Factories and globally scoped features can be declared inside a `FactoryBot.define` block using the following methods:

|       Method Name | Description                                                                                           |
| ----------------: | ----------------------------------------------------------------------------------------------------- |
|         `factory` | declares a new [[§ Factories\|Factory]] definition                                                    |
|        `sequence` | declares a new [[Global Sequences\|Global Sequence]]                                                  |
|           `trait` | declares a new [[Global Traits\|Global Trait]]                                                        |
|          `before` | declares a new [[Global Callbacks\|Global Callback]] to be invoked *before* an event                  |
|           `after` | declares a new  [[Global Callbacks\|Global Callback]] to be invoked *after* an event                  |
|        `callback` | declares a new [[Global Callbacks\|Global Callback]] to hook onto an event by name                    |
| `initialize_with` | global customization of object initialization<br>See [[Customizing the Initialization of Objects]].   |
|       `to_create` | global customization of object persistence<br>See [[Customizing the Persistence of Object Instances]] |
|     `skip_create` | globally disable object persistence<br>See [[Disabling the Persistence of Object Instances]]          |

### Syntax Available Inside `FactoryBot.update`

Factories, and only factories, can be updated within a `FactoryBot.update` block using the `factory` method.

| Method Name | Description                        |
| ----------- | ---------------------------------- |
| `factory`   | reopens a Factory for modification |

## Nested DSL Methods

The DSL methods below are made available within any block passed to a `factory` or `trait` methods:

|            Method Name | Description                                                                                                                                                                                                                                                                      |
| ---------------------: | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|              `factory` | declares a new [[Child Factories\|Child Factory]] definition                                                                                                                                                                                                                     |
|        `add_attribute` | declares a new [[Explicit Attributes\|Explicit Attribute]]                                                                                                                                                                                                                       |
|          `association` | declares a new [[Explicit Associations\|Explicit Association]]                                                                                                                                                                                                                   |
|            `transient` | starts a new [[Transient Attributes]] block                                                                                                                                                                                                                                      |
|             `sequence` | declares a new factory scoped [[Sequences\|Sequence]]                                                                                                                                                                                                                            |
|                `trait` | declares a new factory scoped [[Traits\|Trait]]                                                                                                                                                                                                                                  |
|      `traits_for_enum` | declares a new [[Enum Traits\|Enum Trait]]                                                                                                                                                                                                                                       |
|               `before` | declares a new factory scoped [[Callbacks\|Callback]] to be invoked *before* an event                                                                                                                                                                                            |
|                `after` | declares a new factory scoped [[Callbacks\|Callback]] to be invoked *after* an event                                                                                                                                                                                             |
|             `callback` | declares a new factory scoped [[Callbacks\|Callback]] to hook onto an event by name                                                                                                                                                                                              |
|      `initialize_with` | customizes object initialization for the current factory or trait<br>See [[Customizing the Initialization of Objects]].                                                                                                                                                          |
|            `to_create` | customizes object persistence for the current factory or trait<br>See [[Customizing the Persistence of Object Instances]]                                                                                                                                                        |
|          `skip_create` | disables object persistence for the current factory or trait<br>See [[Disabling the Persistence of Object Instances]]                                                                                                                                                            |
| ✱ *any missing method* | declares a new [[Implicit Attributes\|Implicit Attribute]], declares a new [[Implicit Associations\|Implicit Association]], or activate a [[Trait]]. This relies on Ruby's `method_missing` metaprogramming hook. For more information, see [[Missing Method Shorthand Syntax]]. |

For more information see  [[Factory Definition Syntax]].
